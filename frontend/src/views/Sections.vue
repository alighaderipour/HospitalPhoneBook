<template>
  <div class="section-container">
    <h2>Section List</h2>
    <div v-if="loading" class="status">Loading...</div>
    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="sections.length" class="section-list">
      <li v-for="section in sections" :key="section.SectionID" class="section-item">
        <h3>{{ section.SectionName }}</h3>
        <p>{{ section.Description }}</p>
      </li>
    </ul>
    <p v-else class="status">No section found</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      sections: [],
      loading: false,
      error: "",
    };
  },
  created() {
    this.fetchSections();
  },
  methods: {
    async fetchSections() {
      this.loading = true;
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/sections");
        this.sections = response.data;
      } catch (error) {
        this.error = "Failed to load sections: " + (error.response?.data?.error || error.message);
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.section-container {
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

.section-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.section-item {
  padding: 16px;
  background-color: #f9f9f9;
  border-left: 5px solid #3498db;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.section-item:hover {
  background-color: #f0f8ff;
}

.section-item h3 {
  margin: 0 0 6px;
  font-size: 18px;
  color: #34495e;
}

.section-item p {
  margin: 0;
  color: #555;
}
</style>
