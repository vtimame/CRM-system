import axios from "axios";

export default {
  async loadChecklists(card_id) {
    try {
      return await axios.get("kanban/checklists", { params: { card_id } });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeChecklist(payload) {
    try {
      return await axios.post("kanban/checklists", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateChecklist(payload) {
    try {
      return await axios.put(`kanban/checklists/${payload._id}`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
