import axios from "axios";

export default {
  async pushMember(card_id, member_id) {
    try {
      return await axios.post(`kanban/cards/${card_id}/members`, { member_id });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async pullMember(card_id, member_id) {
    try {
      return await axios.delete(`kanban/cards/${card_id}/members/${member_id}`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
