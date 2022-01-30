import axios from "axios";

export default {
  async loadRoles() {
    try {
      return await axios.get("roles");
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
