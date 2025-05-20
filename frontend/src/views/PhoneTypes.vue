<template>
  <div class="phonetype-container">
    <h2>Phone Type List</h2>

    <button @click="fetchPhoneTypes" class="refresh-button" :disabled="loading">
      {{ loading ? 'Loading...' : 'Reload' }}
    </button>

    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="!loading && !error && phoneTypes.length" class="phonetype-list">
      <li
        v-for="phonetype in phoneTypes"
        :key="phonetype.phoneTypeId"
        class="phonetype-item"
      >
        <h3>{{ phonetype.phoneTypeId }}</h3>
        <p>{{ phonetype.phoneTypeName }}</p>
      </li>
    </ul>

    <p v-else-if="!loading && !error" class="status">No phone types found.</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "PhoneType",
  data() {
    return {
      phoneTypes: [],
      loading: false,
      error: "",
    };
  },
  created() {
    this.fetchPhoneTypes();
  },
  methods: {
    async fetchPhoneTypes() {
      this.loading = true;
      this.error = "";
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/phonetypes");
        // Assuming the API now returns camelCase keys like phoneTypeId
        this.phoneTypes = response.data;
      } catch (err) {
        this.error =
          "Failed to load phone types: " + (err.response?.data?.error || err.message);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.phonetype-container {
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

.phonetype-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.phonetype-item {
  padding: 16px;
  background-color: #f9f9f9;
  border-left: 5px solid #3498db;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.phonetype-item:hover {
  background-color: #f0f8ff;
}

.phonetype-item h3 {
  margin: 0 0 6px;
  font-size: 18px;
  color: #34495e;
}

.phonetype-item p {
  margin: 0;
  color: #555;
}
</style>
