import axios from "axios";

export default {
  async loadAttachments(ids) {
    try {
      return await axios.get("kanban/attachments", { params: { ids } });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateAttachment(payload) {
    try {
      return await axios.put(`kanban/attachments/${payload._id}`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async deleteAttachment(card_id, attachment_id) {
    try {
      return await axios.delete(
        `kanban/cards/${card_id}/attachments/${attachment_id}`
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
