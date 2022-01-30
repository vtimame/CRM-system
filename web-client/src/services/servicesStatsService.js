import axios from "axios";

export default {
  async loadCards(payload) {
    try {
      return await axios.get("stats/servicesStats", { params: payload });
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
