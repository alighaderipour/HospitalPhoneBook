<template>
  <div class="phone-container">
    <h2>Phonenumber List</h2>
    <div v-if="loading" class="status">Loading...</div>
    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="phonenumbers.length" class="phone-list">
      <li v-for="phonenumber in phonenumbers" :key="phonenumber.PhoneID" class="phone-item">
        <strong>Job ID:</strong> {{ phonenumber.JobID }} <br />
        <strong>Phone:</strong> {{ phonenumber.PhoneNumber }} <br />
        <strong>Type:</strong> {{ phonenumber.PhoneTypeName || 'Unknown' }}
      </li>
    </ul>
    <p v-else class="status">No Phonenumber found</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      phonenumbers: [],
      loading: false,
      error: "",
    };
  },
  created() {
    this.fetchPhonenumber();
  },
  methods: {
    async fetchPhonenumber() {
      this.loading = true;
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/phones/phonenumbers");
        this.phonenumbers = response.data;
      } catch (error) {
        this.error = "Failed to load phonenumbers: " + (error.response?.data?.error || error.message);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.phone-container {
  max-width: 700px;
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

.phone-item strong {
  color: #34495e;
}
</style>
