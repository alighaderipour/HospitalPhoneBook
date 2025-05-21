<template>
  <div class="jobs-container">
    <h2>Job List</h2>
    <div class="header-buttons">
      <button @click="fetchJobs" class="refresh-button" :disabled="loading">
        {{ loading ? 'Loading...' : 'Reload' }}
      </button>
      <button @click="showAddForm = !showAddForm" class="add-button">
        {{ showAddForm ? 'Cancel Add' : 'Add New' }}
      </button>
    </div>

    <div v-if="loading" class="status">Loading...</div>
    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="jobs.length && !loading && !error" class="job-list">
      <li v-for="job in jobs" :key="job.JobID" class="job-item">
        <!-- DISPLAY MODE -->
        <div v-if="editingId !== job.JobID" class="item-content">
          <h3>{{ job.JobTitle }}</h3>
          <p><strong>Section:</strong> {{ getSectionName(job.SectionID) }}</p>
        </div>

        <!-- EDIT MODE -->
        <div v-else class="item-content edit-mode">
          <input
            v-model="form.JobTitle"
            placeholder="Job Title"
            class="edit-input"
          />
          <select v-model="form.SectionID" class="edit-select">
            <option disabled value="">-- select section --</option>
            <option
              v-for="sec in sectionsList"
              :key="sec.SectionID"
              :value="sec.SectionID"
            >
              {{ sec.SectionName }}
            </option>
          </select>
        </div>

        <!-- ACTIONS -->
        <div class="item-actions">
          <button
            v-if="editingId !== job.JobID"
            @click="startEdit(job)"
            class="action edit"
          >Edit</button>
          <button
            v-else
            @click="saveEdit(job.JobID)"
            class="action save"
            :disabled="saving"
          >Save</button>
          <button
            v-if="editingId === job.JobID"
            @click="cancelEdit"
            class="action cancel"
            :disabled="saving"
          >Cancel</button>
          <button
            v-if="editingId !== job.JobID"
            @click="deleteJob(job.JobID)"
            class="action delete"
            :disabled="loading"
          >Delete</button>
        </div>
      </li>
    </ul>

    <p v-else-if="!loading && !error" class="status">No jobs found</p>

    <!-- Add Form -->
    <div v-if="showAddForm" class="add-form">
      <input v-model="newJob.JobTitle" placeholder="Job Title" class="edit-input" />
      <select v-model="newJob.SectionID" class="edit-select">
        <option disabled value="">-- select section --</option>
        <option
          v-for="sec in sectionsList"
          :key="sec.SectionID"
          :value="sec.SectionID"
        >
          {{ sec.SectionName }}
        </option>
      </select>
      <button @click="createJob" :disabled="saving" class="action save">
        {{ saving ? 'Saving...' : 'Submit' }}
      </button>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "JobList",
  data() {
    return {
      jobs: [],
      sectionsList: [],
      loading: false,
      saving: false,
      error: "",
      editingId: null,
      form: {
        JobTitle: "",
        SectionID: ""
      },
      showAddForm: false,
      newJob: {
        JobTitle: "",
        SectionID: ""
      }
    };
  },
  async created() {
    await this.fetchSections();
    this.fetchJobs();
  },
  methods: {
    async fetchSections() {
      try {
        const { data } = await axios.get("http://127.0.0.1:5000/api/sections");
        this.sectionsList = data;
      } catch (e) {
        console.error("Failed to load sections", e);
      }
    },
    async fetchJobs() {
      this.loading = true;
      this.error = "";
      this.editingId = null;
      try {
        const { data } = await axios.get("http://127.0.0.1:5000/api/jobs");
        this.jobs = data;
      } catch (err) {
        this.error = "Failed to load jobs: " + (err.response?.data?.error || err.message);
      } finally {
        this.loading = false;
      }
    },
    getSectionName(id) {
      const sec = this.sectionsList.find(s => s.SectionID === id);
      return sec ? sec.SectionName : "—";
    },
    startEdit(job) {
      this.editingId = job.JobID;
      this.form.JobTitle = job.JobTitle;
      this.form.SectionID = job.SectionID + "";
    },
    cancelEdit() {
      this.editingId = null;
      this.form.JobTitle = "";
      this.form.SectionID = "";
    },
    async saveEdit(id) {
      if (!this.form.JobTitle.trim() || !this.form.SectionID) {
        alert("Both Job Title and Section are required.");
        return;
      }
      this.saving = true;
      try {
        await axios.put(`http://127.0.0.1:5000/api/jobs/${id}`, {
          JobTitle: this.form.JobTitle.trim(),
          SectionID: Number(this.form.SectionID),
        });
        await this.fetchJobs();
      } catch (err) {
        alert("Failed to update job: " + (err.response?.data?.error || err.message));
      } finally {
        this.saving = false;
      }
    },
    async deleteJob(id) {
      if (!confirm(`Delete Job ID ${id}? This cannot be undone.`)) return;
      this.loading = true;
      try {
        await axios.delete(`http://127.0.0.1:5000/api/jobs/${id}`);
        await this.fetchJobs();
      } catch (err) {
        alert("Failed to delete job: " + (err.response?.data?.error || err.message));
      } finally {
        this.loading = false;
      }
    },
    async createJob() {
      if (!this.newJob.JobTitle.trim() || !this.newJob.SectionID) {
        alert("Both Job Title and Section are required.");
        return;
      }
      this.saving = true;
      try {
        await axios.post("http://127.0.0.1:5000/api/jobs", {
          JobTitle: this.newJob.JobTitle.trim(),
          SectionID: Number(this.newJob.SectionID),
        });
        this.newJob.JobTitle = "";
        this.newJob.SectionID = "";
        this.showAddForm = false;
        await this.fetchJobs();
      } catch (err) {
        alert("Failed to add job: " + (err.response?.data?.error || err.message));
      } finally {
        this.saving = false;
      }
    }
  }
};
</script>

<style scoped>
.jobs-container {
  max-width: 700px;
  margin: 40px auto;
  padding: 24px;
  font-family: 'Segoe UI', Tahoma, sans-serif;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

h2 {
  text-align: center;
  color: #2c3e50;
  margin-bottom: 20px;
}

.refresh-button {
  display: block;
  margin: 0 auto 20px;
  padding: 8px 16px;
  background: #3498db;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
.refresh-button:disabled { background: #95a5a6; }

.status { text-align: center; font-style: italic; color: #7f8c8d; }
.status.error { color: #e74c3c; font-weight: bold; }

.job-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.job-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 16px;
  background: #f9f9f9;
  border-left: 5px solid #3498db;
  border-radius: 8px;
  transition: background 0.3s;
}
.job-item:hover { background: #f0f8ff; }

.item-content { flex: 1; }

.edit-input,
.edit-select {
  width: 100%;
  margin-bottom: 12px;
  padding: 8px;
  font-size: 14px;
  border: 1px solid #ccd0d5;
  border-radius: 4px;
}

.item-actions {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-left: 12px;
}

.action {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  color: #fff;
}
.action.edit { background: #f1c40f; }
.action.save { background: #2ecc71; }
.action.cancel { background: #95a5a6; }
.action.delete { background: #e74c3c; }
.action:disabled { opacity: 0.6; cursor: not-allowed; }

.header-buttons {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-bottom: 20px;
}

.add-button {
  padding: 8px 16px;
  background: #27ae60;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
.add-button:hover {
  background: #229954;
}

.add-form {
  margin-bottom: 24px;
  background: #f0f8ff;
  padding: 16px;
  border-radius: 8px;
}
</style>
