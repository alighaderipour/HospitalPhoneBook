<template>
  <div>
    <h2>User List</h2>
    <div v-if="loading">Loading...</div>
    <div v-if="error" style="color: red">{{ error }}</div>

    <ul v-if="users.length">
      <li v-for="user in users" :key="user.id">
        {{ user.id }} - {{ user.name }} {{ user.family }}
      </li>
    </ul>
    <p v-else>No users found</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
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
      try {
        const response = await axios.get("http://127.0.0.1:5000/users");
        this.users = response.data;
      } catch (error) {
        this.error = "Failed to load users: " + (error.response?.data?.error || error.message);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
/* optional styles */
</style>
