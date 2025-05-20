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
    <div
      v-if="!loading && !error && results.length === 0 && tried"
      class="status"
    >
      No results found.
    </div>

    <!-- Results list -->
    <div v-if="results.length" class="results">
      <div v-for="user in results" :key="user.UserID" class="result-card">
        <h3>{{ user.FirstName }} {{ user.LastName }}</h3>

        <p>
          <strong>Section:</strong>
          {{ user.SectionName || "—" }}
        </p>
        <p>
          <strong>Job Title:</strong>
          {{ user.JobTitle || "—" }}
        </p>

        <div>
          <strong>Phone Numbers:</strong>
          <ul v-if="user.PhoneNumbers.length">
            <li
              v-for="(phone, idx) in user.PhoneNumbers"
              :key="idx"
            >
              {{ phone.PhoneNumber }}
              <em>({{ phone.PhoneTypeName || "Unknown" }})</em>
            </li>
          </ul>
          <p v-else class="no-phone">No phone numbers</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "SearchDirectory",
  data() {
    return {
      query: "",
      results: [],
      loading: false,
      error: "",
      tried: false, // to show "no results" only after first search
    };
  },
  methods: {
    async performSearch() {
      this.tried = true;
      if (!this.query.trim()) {
        this.error = "Please enter a search term.";
        this.results = [];
        return;
      }

      this.loading = true;
      this.error = "";
      this.results = [];

      try {
        const response = await axios.get("http://127.0.0.1:5000/search", {
          params: { q: this.query.trim() },
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
  max-width: 800px;
  margin: 40px auto;
  padding: 24px;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.search-container h2 {
  margin-bottom: 20px;
  font-size: 28px;
  color: #2c3e50;
  text-align: center;
}

.search-bar {
  display: flex;
  gap: 10px;
  margin-bottom: 24px;
}

.search-bar input {
  flex: 1;
  padding: 12px;
  font-size: 16px;
  border-radius: 8px;
  border: 1px solid #ccc;
  transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

.search-bar input:focus {
  border-color: #3498db;
  outline: none;
  box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
}

.search-bar button {
  padding: 12px 20px;
  font-size: 16px;
  background-color: #3498db;
  border: none;
  color: white;
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
  transition: background-color 0.3s ease;
}

.search-bar button:hover {
  background-color: #2980b9;
}

.status {
  font-style: italic;
  color: #7f8c8d;
  margin-bottom: 20px;
  text-align: center;
}

.status.error {
  color: #e74c3c;
  font-weight: bold;
}

.results {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.result-card {
  padding: 20px;
  border: 1px solid #e0e0e0;
  border-radius: 10px;
  background-color: #fdfdfd;
  transition: box-shadow 0.2s ease;
}

.result-card:hover {
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}

.result-card h3 {
  margin: 0 0 10px;
  color: #2c3e50;
}

.result-card p {
  margin: 4px 0;
  color: #34495e;
}

.result-card ul {
  padding-left: 20px;
  margin-top: 6px;
}

.result-card li {
  color: #555;
}

.no-phone {
  font-style: italic;
  color: #999;
  margin: 4px 0 0;
}
</style>
