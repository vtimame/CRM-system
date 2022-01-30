import axios from "axios";

export default {
  async loadDivisions() {
    try {
      return await axios.get("divisions");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async update(id, payload) {
    try {
      return await axios.put(`divisions/${id}`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
