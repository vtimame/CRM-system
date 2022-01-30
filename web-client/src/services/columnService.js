import axios from "axios";

export default {
  async loadColumns(params) {
    try {
      return await axios.get("kanban/columns", { params: params });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadRawColumns() {
    try {
      return await axios.get("kanban/raw-columns");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeColumn(payload) {
    try {
      return await axios.post("kanban/columns", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadThumbnails(payload) {
    try {
      return await axios.get("kanban/thumbnails", { params: payload });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async moveThumbnail(payload) {
    try {
      return await axios.put("kanban/thumbnails/move", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async addCard(payload) {
    try {
      return await axios.post("kanban/cards", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateColumn(payload) {
    try {
      const { column_id } = payload;
      delete payload.column_id;
      return await axios.put(`kanban/columns/${column_id}`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
