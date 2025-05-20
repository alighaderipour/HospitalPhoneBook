<template>
  <div class="phonetype-container">
    <h2>Phone Type List</h2>

    <button @click="fetchPhoneTypes" class="refresh-button" :disabled="loading">
      {{ loading ? 'Loading...' : 'Reload' }}
    </button>

    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="!loading && !error && phoneTypes.length" class="phonetype-list">
      <li
        v-for="pt in phoneTypes"
        :key="pt.phoneTypeId"
        class="phonetype-item"
      >
        <div class="item-content">
          <h3>{{ pt.phoneTypeId }}</h3>
          <p>{{ pt.phoneTypeName }}</p>
        </div>
        <div class="item-actions">
          <button @click="editPhoneType(pt)" class="action edit">Edit</button>
          <button @click="deletePhoneType(pt.phoneTypeId)" class="action delete">Delete</button>
        </div>
      </li>
    </ul>

    <p v-else-if="!loading && !error" class="status">No phone types found.</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "PhoneType",
  data() {
    return {
      phoneTypes: [],
      loading: false,
      error: "",
    };
  },
  created() {
    this.fetchPhoneTypes();
  },
  methods: {
    async fetchPhoneTypes() {
      this.loading = true;
      this.error = "";
      try {
        const response = await axios.get("http://127.0.0.1:5000/api/phonetypes");
        this.phoneTypes = response.data;
      } catch (err) {
        this.error =
          "Failed to load phone types: " + (err.response?.data?.error || err.message);
      } finally {
        this.loading = false;
      }
    },

    // Prompt the user to enter a new name, then send PUT
    async editPhoneType(pt) {
      const newName = window.prompt("New name for PhoneType ID " + pt.phoneTypeId, pt.phoneTypeName);
      if (!newName || newName.trim() === "" || newName === pt.phoneTypeName) {
        return;
      }
      this.loading = true;
      try {
        await axios.put(`http://127.0.0.1:5000/api/phonetypes/${pt.phoneTypeId}`, {
          PhoneTypeName: newName.trim(),
        });
        this.fetchPhoneTypes();
      } catch (err) {
        alert("Failed to update: " + (err.response?.data?.error || err.message));
      } finally {
        this.loading = false;
      }
    },

    // Confirm deletion, then send DELETE
    async deletePhoneType(id) {
      if (!confirm(`Delete PhoneType ID ${id}? This cannot be undone.`)) return;
      this.loading = true;
      try {
        await axios.delete(`http://127.0.0.1:5000/api/phonetypes/${id}`);
        this.fetchPhoneTypes();
      } catch (err) {
        alert("Failed to delete: " + (err.response?.data?.error || err.message));
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>

<style scoped>
.phonetype-container { /* unchanged */ }

.phonetype-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.phonetype-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background-color: #f9f9f9;
  border-left: 5px solid #3498db;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.phonetype-item:hover {
  background-color: #f0f8ff;
}

.item-content h3,
.item-content p { margin: 0; }

.item-actions .action {
  margin-left: 8px;
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
}

.item-actions .edit {
  background-color: #f1c40f;
  color: #fff;
}

.item-actions .edit:hover {
  background-color: #d4ac0d;
}

.item-actions .delete {
  background-color: #e74c3c;
  color: #fff;
}

.item-actions .delete:hover {
  background-color: #c0392b;
}

/* rest of your styles… */
</style>
