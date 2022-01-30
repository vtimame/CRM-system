import axios from "axios";

export default {
  async checkMobilePhone(payload) {
    try {
      return await axios.get("auth/login", { params: payload });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async logIn(payload) {
    try {
      return await axios.post("auth/login", payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async getMe() {
    try {
      return await axios.get("auth/user");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeJwt(jwt) {
    localStorage.setItem("jwt", jwt);
  },
  async getJwt() {
    localStorage.getItem("jwt");
  },
  async removeJwt() {
    localStorage.removeItem("jwt");
  },
  async logout() {
    try {
      return await axios.post("auth/logout");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async sendPassword(login) {
    try {
      return await axios.get("auth/login", { params: { login } });
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
