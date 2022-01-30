import axios from "axios";

export default {
  async loadPhonebook() {
    try {
      return await axios.get(`phonebook`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
