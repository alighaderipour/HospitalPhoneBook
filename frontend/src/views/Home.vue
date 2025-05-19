<template>
  <div>
    <input v-model="name" placeholder="Name" />
    <input v-model="family" placeholder="Family" />
    <button @click="addUser">Add User</button>

    <!-- Feedback messages -->
    <p v-if="successMessage" style="color: green">{{ successMessage }}</p>
    <p v-if="errorMessage" style="color: red">{{ errorMessage }}</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      name: "",
      family: "",
      successMessage: "",
      errorMessage: "",
    };
  },
  methods: {
    async addUser() {
      try {
        const response = await axios.post(
          "http://127.0.0.1:5000/users",
          {
            name: this.name,
            family: this.family,
          },
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        );

        this.successMessage = "User added successfully! ID: " + response.data.id;
        this.name = "";
        this.family = "";
      } catch (error) {
        this.errorMessage = error.response?.data?.error || "Failed to add user";
        console.error("Error:", error);
      }
    },
  },
};
</script>