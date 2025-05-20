<template>
  <nav class="navbar">
    <div class="nav-left">
      <router-link to="/" class="nav-link">Search</router-link>
      <router-link to="/login" class="nav-link" v-if="!authStore.isLoggedIn">Login</router-link>
      <router-link to="/phonenumbers" class="nav-link" v-if="authStore.isAdmin">Phonenumbers</router-link>
      <router-link to="/sections" class="nav-link" v-if="authStore.isAdmin">sections</router-link>
      <button v-if="authStore.isLoggedIn" @click="logout" class="logout-button">Logout</button>
    </div>
  </nav>
</template>

<script>
import { useAuthStore } from '@/store/auth';

export default {
  name: 'Navbar',
  setup() {
    const authStore = useAuthStore();
    return { authStore };
  },
  methods: {
    logout() {
      this.authStore.logout();
      this.$router.push('/login');
    },
  },
};
</script>
