import axios from "axios";

export default {
  async loadEvents(payload) {
    try {
      return await axios.get("stats/managerEvents", { params: payload });
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
