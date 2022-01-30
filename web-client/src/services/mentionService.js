import axios from "axios";

export default {
  async sendMentinos(payload) {
    try {
      if (payload.ids.length > 0) await axios.post("mentions", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
