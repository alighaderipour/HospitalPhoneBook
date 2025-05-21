<template>
  <div class="phonetype-container">
    <h2>Phone Type List</h2>

    <div class="actions">
      <button @click="fetchPhoneTypes" class="refresh-button" :disabled="loading">
        {{ loading ? 'Loading...' : 'Reload' }}
      </button>
    </div>

    <!-- Add new phone type section -->
    <div class="add-section">
      <input
        v-model="newPhoneTypeName"
        type="text"
        placeholder="Enter new phone type name"
        class="add-input"
      />
      <button @click="addNewPhoneType" class="add-button" :disabled="loading || !newPhoneTypeName.trim()">
        Add New
      </button>
    </div>

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
      newPhoneTypeName: "",
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

    async addNewPhoneType() {
      const name = this.newPhoneTypeName.trim();
      if (!name) return;

      this.loading = true;
      try {
        await axios.post("http://127.0.0.1:5000/api/phonetypes", {
          PhoneTypeName: name,
        });
        this.newPhoneTypeName = "";
        this.fetchPhoneTypes();
      } catch (err) {
        alert("Failed to add: " + (err.response?.data?.error || err.message));
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

.actions {
  display: flex;
  gap: 10px;
  margin-bottom: 1rem;
}

.add-button {
  background-color: #2ecc71;
  color: #fff;
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.add-button:hover {
  background-color: #27ae60;
}
.actions {
  margin-bottom: 1rem;
}

.add-section {
  display: flex;
  gap: 10px;
  margin-bottom: 1rem;
}

.add-input {
  flex: 1;
  padding: 6px 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.add-button {
  background-color: #2ecc71;
  color: #fff;
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.add-button:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.add-button:hover:enabled {
  background-color: #27ae60;
}

/* rest of your styles… */
</style>
