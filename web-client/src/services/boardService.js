import axios from "axios";

export default {
  async loadBoards() {
    try {
      return await axios.get("kanban/boards");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadRawBoards() {
    try {
      return await axios.get("kanban/raw/boards");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeBoard(name) {
    try {
      return await axios.post("kanban/boards", { name });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateBoard(payload) {
    try {
      const { board_id } = payload;
      return await axios.put(`kanban/boards/${board_id}`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
