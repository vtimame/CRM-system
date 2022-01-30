import axios from "axios";

export default {
  async loadActions(card_id) {
    try {
      return await axios.get(`kanban/cards/${card_id}/actions`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeComment(payload) {
    const { card_id } = payload;
    try {
      return await axios.post(`kanban/cards/${card_id}/comments`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeCommand(payload) {
    const { card_id } = payload;
    try {
      return await axios.post(`kanban/cards/${card_id}/commands`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateCommand(payload) {
    const { card_id } = payload;
    try {
      return await axios.put(`kanban/cards/${card_id}/commands`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async mentionUsers({ ids, card_id }) {
    try {
      return await axios.post(`kanban/cards/${card_id}/mentions`, {
        mentions: ids
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
