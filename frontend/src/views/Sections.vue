<template>
  <div>
    <h2>Section List</h2>
    <div v-if="loading">Loading...</div>
    <div v-if="error" style="color: red">{{ error }}</div>

    <ul v-if="sections.length">
      <li v-for="section in sections" :key="section.SectionID">
        {{ section.SectionName }} - {{ section.Description }}
      </li>
    </ul>
    <p v-else>No section found</p>
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
