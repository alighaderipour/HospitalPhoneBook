<template>
  <div>
    <h2>Phonenumber List</h2>
    <div v-if="loading">Loading...</div>
    <div v-if="error" style="color: red">{{ error }}</div>

    <ul v-if="phonenumbers.length">
      <li v-for="phonenumber in phonenumbers" :key="phonenumber.PhoneID">
        {{ phonenumber.JobID }} - {{ phonenumber.PhoneNumber }} {{ phonenumber.PhoneTypeName }}
      </li>
    </ul>
    <p v-else>No Phonenumber found</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      phonenumbers: [], // fixed typo
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
/* optional styles */
</style>
