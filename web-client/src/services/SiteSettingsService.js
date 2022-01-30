import axios from "axios";

export default {
  async loadSettings() {
    try {
      return await axios.get("site/settings");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateSettings(payload) {
    try {
      return await axios.put("site/settings", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
