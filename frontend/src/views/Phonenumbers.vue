<template>
  <div class="phone-container">
    <h2>Phone Number List</h2>

    <div class="button-row">
  <button @click="fetchPhonenumbers" class="refresh-button" :disabled="loading">
    {{ loading ? 'Loading...' : 'Reload' }}
  </button>
  <button @click="openAddModal" class="refresh-button">Add New</button>
</div>


    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="!loading && !error && phonenumbers.length" class="phone-list">
      <li
        v-for="phonenumber in phonenumbers"
        :key="phonenumber.PhoneID"
        class="phone-item"
      >
        <div class="phone-content">
          <div class="phone-details">
            <strong>Job ID:</strong> {{ phonenumber.JobID }} <br />
            <strong>Job Title:</strong> {{ phonenumber.JobTitle }} <br />
            <strong>Section:</strong> {{ phonenumber.SectionName }} <br />
            <strong>Phone:</strong> {{ phonenumber.PhoneNumber }} <br />
            <strong>Type:</strong> {{ phonenumber.PhoneTypeName || 'Unknown' }}
          </div>

          <EditDeleteButtons
            @edit="openEditModal(phonenumber)"
            @delete="handleDelete(phonenumber.PhoneID)"
          />
        </div>
      </li>
    </ul>

    <p v-else-if="!loading && !error" class="status">No phone numbers found.</p>

    <!-- Edit Modal -->
    <div v-if="showEditModal" class="modal">
      <div class="modal-content">
        <h3>Edit Phone Number</h3>
        <form @submit.prevent="saveEdit">
          <label for="job">Job Title:</label>
          <select id="job" v-model="editForm.JobID" required>
            <option v-for="job in jobs" :key="job.JobID" :value="job.JobID">
              {{ job.JobTitle }}
            </option>
          </select>

          <label for="section">Section:</label>
          <select id="section" v-model="editForm.SectionID" required>
            <option v-for="section in sections" :key="section.SectionID" :value="section.SectionID">
              {{ section.SectionName }}
            </option>
          </select>

          <label for="phoneType">Phone Type:</label>
          <select id="phoneType" v-model="editForm.PhoneTypeID">
            <option v-for="type in phoneTypes" :key="type.phoneTypeId" :value="type.phoneTypeId">
              {{ type.phoneTypeName }}
            </option>
          </select>

          <label for="phoneNumber">Phone Number:</label>
          <input type="text" id="phoneNumber" v-model="editForm.PhoneNumber" required />

          <button type="submit">Save</button>
          <button type="button" @click="closeEditModal">Cancel</button>
        </form>
      </div>
    </div>
    <!-- Add Modal -->
<div v-if="showAddModal" class="modal">
  <div class="modal-content">
    <h3>Add New Phone Number</h3>
    <form @submit.prevent="submitNewPhoneNumber">
      <label for="add-job">Job Title:</label>
      <select id="add-job" v-model="newForm.JobID" required>
        <option v-for="job in jobs" :key="job.JobID" :value="job.JobID">
          {{ job.JobTitle }}
        </option>
      </select>

      <label for="add-phoneType">Phone Type:</label>
      <select id="add-phoneType" v-model="newForm.PhoneTypeID">
        <option v-for="type in phoneTypes" :key="type.phoneTypeId" :value="type.phoneTypeId">
          {{ type.phoneTypeName }}
        </option>
      </select>

      <label for="add-phoneNumber">Phone Number:</label>
      <input type="text" id="add-phoneNumber" v-model="newForm.PhoneNumber" required />

      <button type="submit">Add</button>
      <button type="button" @click="closeAddModal">Cancel</button>
    </form>
  </div>
</div>

  </div>
</template>

<script>
import axios from "axios";
import EditDeleteButtons from "@/components/EditDeleteButtons.vue";

export default {
  name: "PhoneNumberList",
  components: {
    EditDeleteButtons,
  },
  data() {
    return {
      phonenumbers: [],
      jobs: [],
      sections: [],
      phoneTypes: [],
      loading: false,
      error: "",
      showEditModal: false,
      editForm: {
        PhoneID: null,
        JobID: null,
        SectionID: null,
        PhoneTypeID: null,
        PhoneNumber: "",
      },
      showAddModal: false,
newForm: {
  JobID: null,
  PhoneTypeID: null,
  PhoneNumber: "",
},

    };
  },
  created() {
    this.fetchPhonenumbers();
    this.fetchJobs();
    this.fetchSections();
    this.fetchPhoneTypes();
  },
  methods: {
    async fetchPhonenumbers() {
      this.loading = true;
      this.error = "";
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/phones/phonenumbers");
        this.phonenumbers = response.data;
      } catch (error) {
        this.error = "Failed to load phone numbers: " + (error.response?.data?.error || error.message);
      } finally {
        this.loading = false;
      }
    },
    async fetchJobs() {
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/jobs");
        this.jobs = response.data;
      } catch (error) {
        this.error = "Failed to load jobs.";
      }
    },
    async fetchSections() {
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/sections");
        this.sections = response.data;
      } catch (error) {
        this.error = "Failed to load sections.";
      }
    },
    async fetchPhoneTypes() {
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/phonetypes");
        this.phoneTypes = response.data.map((type) => ({
          phoneTypeId: type.phoneTypeId,
          phoneTypeName: type.phoneTypeName,
        }));
      } catch (error) {
        this.error = "Failed to load phone types.";
      }
    },
    openEditModal(phone) {
      const job = this.jobs.find((j) => j.JobID === phone.JobID);
      this.editForm = {
        PhoneID: phone.PhoneID,
        JobID: phone.JobID,
        SectionID: job ? this.sections.find((s) => s.SectionName === phone.SectionName)?.SectionID : null,
        PhoneTypeID: this.phoneTypes.find((t) => t.phoneTypeName === phone.PhoneTypeName)?.phoneTypeId || null,
        PhoneNumber: phone.PhoneNumber,
      };
      this.showEditModal = true;
    },
    closeEditModal() {
      this.showEditModal = false;
    },
    async saveEdit() {
      try {
        const payload = {
          JobID: this.editForm.JobID,
          PhoneNumber: this.editForm.PhoneNumber,
          PhoneTypeID: this.editForm.PhoneTypeID || null,
        };
        await axios.put(`http://127.0.0.1:5000/api/phones/${this.editForm.PhoneID}`, payload);
        this.closeEditModal();
        this.fetchPhonenumbers(); // Refresh the list
      } catch (error) {
        this.error = "Failed to update phone number: " + (error.response?.data?.error || error.message);
      }
    },
    async handleDelete(phoneId) {
      if (!confirm("Are you sure you want to delete this phone number?")) return;

      try {
        await axios.delete(`http://127.0.0.1:5000/api/phones/${phoneId}`);
        this.phonenumbers = this.phonenumbers.filter((p) => p.PhoneID !== phoneId);
      } catch (error) {
        this.error = "Failed to delete phone number: " + (error.response?.data?.error || error.message);
      }
    },
    openAddModal() {
  this.newForm = {
    JobID: this.jobs.length ? this.jobs[0].JobID : null,
    PhoneTypeID: null,
    PhoneNumber: "",
  };
  this.showAddModal = true;
},
closeAddModal() {
  this.showAddModal = false;
},
async submitNewPhoneNumber() {
  try {
    const payload = {
      JobID: this.newForm.JobID,
      PhoneNumber: this.newForm.PhoneNumber,
      PhoneTypeID: this.newForm.PhoneTypeID || null,
    };
    await axios.post("http://127.0.0.1:5000/api/phones/add/phonenumber", payload);
    this.closeAddModal();
    this.fetchPhonenumbers();
  } catch (error) {
    this.error = "Failed to add phone number: " + (error.response?.data?.error || error.message);
  }
}

  },
};
</script>

<style scoped>
.phone-container {
  max-width: 800px;
  margin: 40px auto;
  padding: 24px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

h2 {
  font-size: 26px;
  color: #2c3e50;
  margin-bottom: 20px;
  text-align: center;
}

.refresh-button {
  display: block;
  margin: 0 auto 20px;
  padding: 8px 16px;
  font-size: 14px;
  background-color: #3498db;
  color: #fff;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.refresh-button:hover {
  background-color: #2980b9;
}

.refresh-button:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
}

.status {
  text-align: center;
  font-style: italic;
  color: #7f8c8d;
  margin-bottom: 16px;
}

.status.error {
  color: #e74c3c;
  font-weight: bold;
}

.phone-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.phone-item {
  padding: 16px;
  background-color: #f9f9f9;
  border-left: 5px solid #3498db;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.phone-item:hover {
  background-color: #f0f8ff;
}

.phone-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.phone-details strong {
  min-width: 80px;
  display: inline-block;
  color: #2c3e50;
}

/* Modal Styles */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background: white;
  padding: 20px;
  border-radius: 8px;
  width: 400px;
}

form {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

label {
  font-weight: bold;
}

select,
input {
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

button {
  padding: 8px 16px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background-color: #2980b9;
}

button[type="button"] {
  background-color: #95a5a6;
}

button[type="button"]:hover {
  background-color: #7f8c8d;
}
.button-row {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-bottom: 20px;
}

</style>