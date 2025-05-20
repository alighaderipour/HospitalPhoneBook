<template>
  <div class="users-container">
    <h2>User List</h2>

    <button @click="fetchUsers" class="refresh-button" :disabled="loading">
      {{ loading ? 'Loading...' : 'Reload' }}
    </button>

    <div v-if="loading" class="status">Loading...</div>
    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="users.length && !loading && !error" class="user-list">
      <li
        v-for="usr in users"
        :key="usr.UserID"
        class="user-item"
      >
        <!-- DISPLAY MODE -->
        <div v-if="editingId !== usr.UserID" class="item-content">
          <h3>{{ usr.FirstName }} {{ usr.LastName }}</h3>
          <p><strong>Email:</strong> {{ usr.Email }}</p>
          <p><strong>Section:</strong> {{ usr.SectionName }}</p>
          <p><strong>Job:</strong> {{ usr.JobTitle }}</p>
          <p><strong>Admin:</strong> {{ usr.is_admin ? "Yes" : "No" }}</p>
          <p><strong>Active:</strong> {{ usr.IsActive ? "Active" : "Inactive" }}</p>
        </div>

        <!-- EDIT MODE -->
        <div v-else class="item-content edit-mode">
          <input
            v-model="form.FirstName"
            placeholder="First Name"
            class="edit-input"
          />
          <input
            v-model="form.LastName"
            placeholder="Last Name"
            class="edit-input"
          />
          <input
            v-model="form.Email"
            placeholder="Email"
            class="edit-input"
          />

          <label>
            Section:
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
          </label>

          <label>
            Job:
            <select v-model="form.JobID" class="edit-select">
              <option disabled value="">-- select job --</option>
              <option
                v-for="job in jobsList"
                :key="job.JobID"
                :value="job.JobID"
              >
                {{ job.JobTitle }}
              </option>
            </select>
          </label>

          <label>
            Admin:
            <input type="checkbox" v-model="form.is_admin" />
          </label>
          <label>
            Active:
            <input type="checkbox" v-model="form.IsActive" />
          </label>
        </div>

        <!-- ACTIONS -->
        <div class="item-actions">
          <button
            v-if="editingId !== usr.UserID"
            @click="startEdit(usr)"
            class="action edit"
          >Edit</button>
          <button
            v-else
            @click="saveEdit(usr.UserID)"
            class="action save"
            :disabled="saving"
          >Save</button>
          <button
            v-if="editingId === usr.UserID"
            @click="cancelEdit"
            class="action cancel"
            :disabled="saving"
          >Cancel</button>
          <button
            v-if="editingId !== usr.UserID"
            @click="deleteUser(usr.UserID)"
            class="action delete"
            :disabled="loading"
          >Delete</button>
        </div>
      </li>
    </ul>

    <p v-else-if="!loading && !error" class="status">No users found</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "UserList",
  data() {
    return {
      users: [],
      sectionsList: [],
      jobsList: [],
      loading: false,
      saving: false,
      error: "",
      editingId: null,
      form: {
        FirstName: "",
        LastName: "",
        Email: "",
        SectionID: "",
        JobID: "",
        is_admin: false,
        IsActive: true,
      },
    };
  },
  async created() {
    await Promise.all([this.fetchSectionsList(), this.fetchJobsList()]);
    this.fetchUsers();
  },
  methods: {
    async fetchUsers() {
      this.loading = true;
      this.error = "";
      this.editingId = null;
      try {
        const { data } = await axios.get("http://127.0.0.1:5000/api/users");
        // Expect each user to include SectionID, SectionName, JobID, JobTitle
        this.users = data;
      } catch (err) {
        this.error =
          "Failed to load users: " + (err.response?.data?.error || err.message);
      } finally {
        this.loading = false;
      }
    },

    async fetchSectionsList() {
      try {
        const { data } = await axios.get("http://127.0.0.1:5000/api/sections");
        this.sectionsList = data;
      } catch {
        this.sectionsList = [];
      }
    },

    async fetchJobsList() {
      try {
        const { data } = await axios.get("http://127.0.0.1:5000/api/jobs");
        this.jobsList = data;
      } catch {
        this.jobsList = [];
      }
    },

    startEdit(usr) {
      this.editingId = usr.UserID;
      this.form = {
        FirstName: usr.FirstName,
        LastName: usr.LastName,
        Email: usr.Email,
        SectionID: usr.SectionID || "",
        JobID: usr.JobID || "",
        is_admin: usr.is_admin,
        IsActive: usr.IsActive,
      };
    },

    cancelEdit() {
      this.editingId = null;
      this.form = {
        FirstName: "",
        LastName: "",
        Email: "",
        SectionID: "",
        JobID: "",
        is_admin: false,
        IsActive: true,
      };
    },

    async saveEdit(id) {
      // Basic validation
      if (
        !this.form.FirstName.trim() ||
        !this.form.LastName.trim() ||
        !this.form.Email.trim() ||
        !this.form.SectionID ||
        !this.form.JobID
      ) {
        alert("All fields are required, including Section and Job.");
        return;
      }

      this.saving = true;
      try {
        await axios.put(`http://127.0.0.1:5000/api/users/${id}`, {
  FirstName: this.form.FirstName.trim(),
  LastName:  this.form.LastName.trim(),
  Email:     this.form.Email.trim(),
  SectionID: Number(this.form.SectionID),
  JobID:     Number(this.form.JobID),
  is_admin:  this.form.is_admin,
  IsActive:  this.form.IsActive,
});
        await this.fetchUsers();
      } catch (err) {
        alert("Failed to update user: " + (err.response?.data?.error || err.message));
      } finally {
        this.saving = false;
      }
    },

    async deleteUser(id) {
      if (!confirm(`Delete User ID ${id}? This cannot be undone.`)) return;
      this.loading = true;
      try {
        await axios.delete(`http://127.0.0.1:5000/api/users/${id}`);
        await this.fetchUsers();
      } catch (err) {
        alert("Failed to delete user: " + (err.response?.data?.error || err.message));
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
/* your existing styles… */

.edit-select {
  display: block;
  width: 100%;
  margin: 6px 0 12px;
  padding: 8px;
  font-size: 14px;
  border: 1px solid #ccd0d5;
  border-radius: 4px;
}
</style>
