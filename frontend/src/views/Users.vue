<template>
  <div class="users-container">
    <h2>User Management</h2>

    <!-- Action Buttons -->
    <div class="action-buttons">
      <button @click="fetchUsers" :disabled="loading">
        {{ loading ? 'Loading...' : 'Reload' }}
      </button>
      <button @click="toggleAddForm" :disabled="editingId || showAddForm">
        Add User
      </button>
    </div>

    <!-- Add New User Form -->
    <div class="add-user-form" v-if="showAddForm">
      <h3>Add New User</h3>
      <input v-model="form.FirstName" placeholder="First Name" />
      <input v-model="form.LastName" placeholder="Last Name" />
      <input v-model="form.Mobile" placeholder="Mobile" />

      <select v-model="form.SectionID">
        <option disabled value="">-- select section --</option>
        <option v-for="sec in sectionsList" :key="sec.SectionID" :value="sec.SectionID">
          {{ sec.SectionName }}
        </option>
      </select>

      <select v-model="form.JobID">
        <option disabled value="">-- select job --</option>
        <option v-for="job in jobsList" :key="job.JobID" :value="job.JobID">
          {{ job.JobTitle }}
        </option>
      </select>

      <label><input type="checkbox" v-model="form.is_admin" /> Admin</label>
      <label><input type="checkbox" v-model="form.IsActive" /> Active</label>

      <button @click="addUser" :disabled="saving">Submit</button>
      <button @click="toggleAddForm">Cancel</button>
    </div>

    <!-- Users Table -->
    <table class="user-table">
      <thead>
        <tr>
          <th>Name</th>
          <th>Mobile</th>
          <th>Section</th>
          <th>Job</th>
          <th>Admin</th>
          <th>Active</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="usr in users" :key="usr.UserID">
          <template v-if="editingId === usr.UserID">
            <td><input v-model="form.FirstName" /></td>
            <td><input v-model="form.Mobile" /></td>
            <td>
              <select v-model="form.SectionID">
                <option disabled value="">--</option>
                <option v-for="sec in sectionsList" :key="sec.SectionID" :value="sec.SectionID">
                  {{ sec.SectionName }}
                </option>
              </select>
            </td>
            <td>
              <select v-model="form.JobID">
                <option disabled value="">--</option>
                <option v-for="job in jobsList" :key="job.JobID" :value="job.JobID">
                  {{ job.JobTitle }}
                </option>
              </select>
            </td>
            <td><input type="checkbox" v-model="form.is_admin" /></td>
            <td><input type="checkbox" v-model="form.IsActive" /></td>
            <td>
              <button @click="saveEdit(usr.UserID)" :disabled="saving">Save</button>
              <button @click="cancelEdit">Cancel</button>
            </td>
          </template>
          <template v-else>
            <td>{{ usr.FirstName }} {{ usr.LastName }}</td>
            <td>{{ usr.Mobile }}</td>
            <td>{{ usr.SectionName }}</td>
            <td>{{ usr.JobTitle }}</td>
            <td>{{ usr.is_admin ? 'Yes' : 'No' }}</td>
            <td>{{ usr.IsActive ? 'Yes' : 'No' }}</td>
            <td>
              <button @click="startEdit(usr)" :disabled="showAddForm">Edit</button>
              <button @click="deleteUser(usr.UserID)" :disabled="showAddForm">Delete</button>
            </td>
          </template>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'Users',
  data() {
    return {
      users: [],
      sectionsList: [],
      jobsList: [],
      form: {
        FirstName: '',
        LastName: '',
        Mobile: '',
        SectionID: '',
        JobID: '',
        is_admin: false,
        IsActive: true
      },
      editingId: null,
      showAddForm: false,
      loading: false,
      saving: false
    };
  },
  async created() {
    await Promise.all([this.fetchSectionsList(), this.fetchJobsList()]);
    this.fetchUsers();
  },
  methods: {
    async fetchUsers() {
      this.loading = true;
      try {
        const { data } = await axios.get('http://127.0.0.1:5000/api/users');
        this.users = data;
      } finally {
        this.loading = false;
      }
    },
    async fetchSectionsList() {
      const { data } = await axios.get('http://127.0.0.1:5000/api/sections');
      this.sectionsList = data;
    },
    async fetchJobsList() {
      const { data } = await axios.get('http://127.0.0.1:5000/api/jobs');
      this.jobsList = data;
    },
    async addUser() {
      if (!this.form.FirstName || !this.form.LastName || !this.form.Mobile || !this.form.SectionID || !this.form.JobID) {
        alert('All fields are required');
        return;
      }
      this.saving = true;
      try {
        await axios.post('http://127.0.0.1:5000/api/users', this.form);
        this.resetForm();
        this.showAddForm = false;
        this.fetchUsers();
      } catch (err) {
        alert(err.response?.data?.error || 'Add failed');
      } finally {
        this.saving = false;
      }
    },
    toggleAddForm() {
      this.showAddForm = !this.showAddForm;
      this.resetForm();
    },
    startEdit(user) {
      this.editingId = user.UserID;
      this.form = { ...user };
    },
    cancelEdit() {
      this.editingId = null;
      this.resetForm();
    },
    async saveEdit(id) {
      this.saving = true;
      try {
        await axios.put(`http://127.0.0.1:5000/api/users/${id}`, this.form);
        this.cancelEdit();
        this.fetchUsers();
      } catch (err) {
        alert(err.response?.data?.error || 'Update failed');
      } finally {
        this.saving = false;
      }
    },
    async deleteUser(id) {
      if (!confirm('Delete user?')) return;
      await axios.delete(`http://127.0.0.1:5000/api/users/${id}`);
      this.fetchUsers();
    },
    resetForm() {
      this.form = {
        FirstName: '',
        LastName: '',
        Mobile: '',
        SectionID: '',
        JobID: '',
        is_admin: false,
        IsActive: true
      };
    }
  }
};
</script>

<style scoped>
.users-container {
  padding: 20px;
  max-width: 1000px;
  margin: auto;
}

.action-buttons,
.add-user-form {
  margin-bottom: 20px;
}

input,
select {
  display: block;
  margin: 6px 0;
  padding: 8px;
  width: 100%;
  max-width: 300px;
}

button {
  margin: 4px 8px 4px 0;
  padding: 6px 12px;
}

.user-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

.user-table th,
.user-table td {
  border: 1px solid #ccc;
  padding: 8px;
  text-align: left;
}

.user-table th {
  background-color: #f0f0f0;
}
</style>
