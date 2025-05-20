import { createApp } from 'vue';
import { createPinia } from 'pinia';
import App from './App.vue';
import router from './router';

const app = createApp(App);
app.use(createPinia()); // ✅ Make sure this is included
app.use(router);
app.mount('#app');
