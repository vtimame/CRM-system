import axios from "axios";

export default {
  async loadSettings() {
    try {
      return await axios.get("settings");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateSettings(payload) {
    try {
      return await axios.put("settings", { payload });
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
