<template>
  <div class="login-container">
    <div class="login-card">
      <h2>Login</h2>
      <form @submit.prevent="handleLogin">
        <input v-model="userID" type="text" placeholder="User ID" required />
        <input v-model="password" type="password" placeholder="Password" required />
        <button type="submit" :disabled="loading">
          {{ loading ? 'Logging in...' : 'Login' }}
        </button>
        <p class="error" v-if="error">{{ error }}</p>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { useAuthStore } from '@/store/auth'; // Pinia store

export default {
  name: 'Login',
  data() {
    return {
      userID: '',
      password: '',
      loading: false,
      error: '',
    };
  },
  setup() {
    const authStore = useAuthStore();
    return { authStore };
  },
  methods: {
    async handleLogin() {
      this.loading = true;
      this.error = '';

      try {
        const response = await axios.post('http://127.0.0.1:5000/login', {
          UserID: this.userID,
          password: this.password,
        });

        // ✅ Store user data in Pinia state
        this.authStore.setUser(response.data);



        this.$router.push('/');
      } catch (err) {
        this.error = err.response?.data?.error || 'Login failed. Please try again.';
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>
