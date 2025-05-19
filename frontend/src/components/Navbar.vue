<template>
  <nav>
    <router-link to="/">Home</router-link>
    |
    <router-link to="/test">Go to Test Page</router-link>
  </nav>
</template>

<script>
export default {
  name: 'Navbar'
}
</script>

<style scoped>
/* Animate nav slide-down on mount */
@keyframes slideDown {
  from {
    transform: translateY(-20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

nav {
  background-color: #f0f0f0;
  padding: 10px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  animation: slideDown 0.5s ease-out;
  transition: background-color 0.3s ease;
}

/* Style for router-link with smooth color & scale transition */
router-link {
  margin: 0 10px;
  text-decoration: none;
  color: #333;
  transition: color 0.3s ease, transform 0.3s ease;
}

router-link:hover {
  color: royalblue;
  transform: scale(1.1);
}
</style>
