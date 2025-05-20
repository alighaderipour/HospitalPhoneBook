import { createRouter, createWebHistory } from "vue-router";
import Home from "../views/Home.vue";
import Phonenumbers from "../views/Phonenumbers.vue";
import Login from "../views/Login.vue";
import Section from "../views/Sections.vue";
import PhoneTypes from "../views/PhoneTypes.vue";
import Users from "../views/Users.vue";
import Jobs from "../views/Jobs.vue";

const routes = [
  {
    path: "/",
    name: "Home",
    component: Home,
  },
  {
    path: "/phonenumbers",
    name: "phonenumbers",
    component: Phonenumbers,
  },
    {
    path: "/login",
    name: "login",
    component: Login,
  },
    {
    path: "/sections",
    name: "sections",
    component: Section,
  },
    {
    path: "/phonetypes",
    name: "phonetypes",
    component: PhoneTypes,
  },
    {
    path: "/users",
    name: "users",
    component: Users,
  },
    {
    path: "/jobs",
    name: "jobs",
    component: Jobs,
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
