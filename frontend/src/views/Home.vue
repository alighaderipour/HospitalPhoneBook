<template>
  <div class="search-container">
    <h2>Search Directory</h2>
    <div class="search-bar">
      <input
        v-model="query"
        @keyup.enter="performSearch"
        type="text"
        placeholder="Search name, job, phone number, or section..."
      />
      <button @click="performSearch">Search</button>
    </div>

    <!-- Status messages -->
    <div v-if="loading" class="status">Searching...</div>
    <div v-if="error" class="status error">{{ error }}</div>
    <div v-if="results.length === 0 && !loading && !error" class="status">No results found.</div>

    <!-- Results list -->
    <div v-if="results.length" class="results">
      <div v-for="user in results" :key="user.UserID" class="result-card">
        <h3>{{ user.FirstName }} {{ user.LastName }}</h3>
        <p><strong>Section:</strong> {{ user.SectionName }}</p>
        <p><strong>Job Title:</strong> {{ user.JobTitle }}</p>
        <div v-if="user.PhoneNumbers.length">
          <p><strong>Phone Numbers:</strong></p>
          <ul>
            <li v-for="(phone, idx) in user.PhoneNumbers" :key="idx">
              {{ phone.PhoneNumber }} ({{ phone.PhoneTypeName || 'Unknown' }})
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      query: "",
      results: [],
      loading: false,
      error: "",
    };
  },
  methods: {
    async performSearch() {
      if (!this.query.trim()) {
        this.error = "Please enter a search term.";
        return;
      }

      this.loading = true;
      this.error = "";
      this.results = [];

      try {
        const response = await axios.get("http://127.0.0.1:5000/search", {
          params: { q: this.query },
        });
        this.results = response.data;
      } catch (err) {
        this.error = err.response?.data?.error || "Search failed.";
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.search-container {
  max-width: 700px;
  margin: 0 auto;
  padding: 24px;
  font-family: Arial, sans-serif;
}

.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.search-bar input {
  flex: 1;
  padding: 10px;
  font-size: 16px;
  border-radius: 6px;
  border: 1px solid #ccc;
  transition: border-color 0.3s ease;
}

.search-bar input:focus {
  border-color: #007bff;
  outline: none;
}

.search-bar button {
  padding: 10px 16px;
  font-size: 16px;
  background-color: #007bff;
  border: none;
  color: white;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.search-bar button:hover {
  background-color: #0056b3;
}

.status {
  font-style: italic;
  color: #555;
  margin-bottom: 16px;
}

.status.error {
  color: red;
}

.results {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.result-card {
  padding: 16px;
  border: 1px solid #eee;
  border-radius: 8px;
  background: #fafafa;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}
</style>
