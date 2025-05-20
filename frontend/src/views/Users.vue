<template>
  <div class="users-container">
    <h2>User List</h2>

    <button @click="fetchUsers" class="refresh-button" :disabled="loading">
      {{ loading ? 'Loading...' : 'Reload' }}
    </button>

    <div v-if="loading" class="status">Loading...</div>
    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="users.length" class="user-list">
      <li v-for="user in users" :key="user.UserID" class="user-item">
        <h3>{{ user.FirstName }} {{ user.LastName }}</h3>
        <p><strong>Email:</strong> {{ user.Email }}</p>
        <p><strong>Admin:</strong> {{ user.is_admin ? "Yes" : "No" }}</p>
        <p><strong>Active:</strong> {{ user.IsActive ? "Active" : "Inactive" }}</p>
      </li>
    </ul>

    <p v-else class="status">No users found</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "UserList",
  data() {
    return {
      users: [],
      loading: false,
      error: "",
    };
  },
  created() {
    this.fetchUsers();
  },
  methods: {
    async fetchUsers() {
      this.loading = true;
      this.error = "";

      try {
        const response = await axios.get("http://127.0.0.1:5000/api/users");
        console.log("Fetched users:", response.data); // Debugging
        this.users = response.data;
      } catch (error) {
        console.error("API Error:", error); // Debugging
        this.error = "Failed to load users: " + (error.response?.data?.error || error.message);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.users-container {
  max-width: 700px;
  margin: 40px auto;
  padding: 24px;
  font-family: 'Segoe UI', Tahoma, sans-serif;
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

.user-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.user-item {
  padding: 16px;
  background-color: #f9f9f9;
  border-left: 5px solid #3498db;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.user-item:hover {
  background-color: #f0f8ff;
}

.user-item h3 {
  margin: 0 0 6px;
  font-size: 18px;
  color: #34495e;
}

.user-item p {
  margin: 0;
  color: #555;
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
</style>
