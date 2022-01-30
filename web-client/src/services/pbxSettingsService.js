import axios from "axios";

export default {
  async loadSettings() {
    try {
      return await axios.get("pbx/settings");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateSettings(payload) {
    try {
      return await axios.put("pbx/settings", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
