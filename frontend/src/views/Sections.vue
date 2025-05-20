<template>
  <div class="section-container">
    <h2>Section List</h2>
    <button @click="fetchSections" class="refresh-button" :disabled="loading">
      {{ loading ? 'Loading...' : 'Reload' }}
    </button>

    <div v-if="loading" class="status">Loading...</div>
    <div v-if="error" class="status error">{{ error }}</div>

    <ul v-if="sections.length && !loading && !error" class="section-list">
      <li
        v-for="sec in sections"
        :key="sec.SectionID"
        class="section-item"
      >
        <!-- DISPLAY MODE -->
        <div v-if="editingId !== sec.SectionID" class="item-content">
          <h3>{{ sec.SectionName }}</h3>
          <p>{{ sec.Description }}</p>
        </div>

        <!-- EDIT MODE -->
        <div v-else class="item-content edit-mode">
          <input
            v-model="form.SectionName"
            placeholder="Section Name"
            class="edit-input"
          />
          <textarea
            v-model="form.Description"
            placeholder="Description"
            class="edit-textarea"
          ></textarea>
        </div>

        <!-- ACTIONS -->
        <div class="item-actions">
          <button
            v-if="editingId !== sec.SectionID"
            @click="startEdit(sec)"
            class="action edit"
          >Edit</button>
          <button
            v-else
            @click="saveEdit(sec.SectionID)"
            class="action save"
            :disabled="saving"
          >Save</button>
          <button
            v-if="editingId === sec.SectionID"
            @click="cancelEdit"
            class="action cancel"
            :disabled="saving"
          >Cancel</button>
          <button
            v-if="editingId !== sec.SectionID"
            @click="deleteSection(sec.SectionID)"
            class="action delete"
            :disabled="loading"
          >Delete</button>
        </div>
      </li>
    </ul>

    <p v-else-if="!loading && !error" class="status">No section found</p>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      sections: [],
      loading: false,
      saving: false,
      error: "",
      editingId: null,
      form: {
        SectionName: "",
        Description: ""
      }
    };
  },
  created() {
    this.fetchSections();
  },
  methods: {
    async fetchSections() {
      this.loading = true;
      this.error = "";
      this.editingId = null;
      try {
        const { data } = await axios.get("http://127.0.0.1:5000/api/sections");
        this.sections = data;
      } catch (err) {
        this.error =
          "Failed to load sections: " + (err.response?.data?.error || err.message);
      } finally {
        this.loading = false;
      }
    },

    startEdit(sec) {
      // enter edit mode and populate form
      this.editingId = sec.SectionID;
      this.form.SectionName = sec.SectionName;
      this.form.Description = sec.Description || "";
    },

    cancelEdit() {
      this.editingId = null;
      this.form.SectionName = "";
      this.form.Description = "";
    },

    async saveEdit(id) {
      if (!this.form.SectionName.trim()) {
        alert("SectionName cannot be empty.");
        return;
      }
      this.saving = true;
      try {
        await axios.put(`http://127.0.0.1:5000/api/sections/${id}`, {
          SectionName: this.form.SectionName.trim(),
          Description: this.form.Description.trim()
        });
        await this.fetchSections();
      } catch (err) {
        alert("Failed to update: " + (err.response?.data?.error || err.message));
      } finally {
        this.saving = false;
      }
    },

    async deleteSection(id) {
      if (!confirm(`Delete Section ID ${id}?`)) return;
      this.loading = true;
      try {
        await axios.delete(`http://127.0.0.1:5000/api/sections/${id}`);
        await this.fetchSections();
      } catch (err) {
        alert("Failed to delete: " + (err.response?.data?.error || err.message));
      } finally {
        this.loading = false;
      }
    }
  }
};
</script>

<style scoped>
.section-container { /* unchanged */ }

.section-list {
  list-style: none;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.section-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 16px;
  background-color: #f9f9f9;
  border-left: 5px solid #3498db;
  border-radius: 8px;
  transition: background-color 0.3s ease;
}

.section-item:hover {
  background-color: #f0f8ff;
}

.item-content {
  flex: 1;
}

.edit-mode .edit-input,
.edit-mode .edit-textarea {
  width: 100%;
  margin-bottom: 8px;
  padding: 8px;
  font-size: 14px;
  border: 1px solid #ccd0d5;
  border-radius: 4px;
}

.edit-textarea {
  resize: vertical;
  min-height: 60px;
}

.item-actions {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-left: 12px;
}

.item-actions .action {
  padding: 6px 12px;
  font-size: 13px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.item-actions .edit {
  background-color: #f1c40f;
  color: #fff;
}

.item-actions .save {
  background-color: #2ecc71;
  color: #fff;
}

.item-actions .cancel {
  background-color: #95a5a6;
  color: #fff;
}

.item-actions .delete {
  background-color: #e74c3c;
  color: #fff;
}

.action:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.refresh-button { /* unchanged */ }
</style>
