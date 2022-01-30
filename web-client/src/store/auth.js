import Vue from "vue";
import authService from "../services/authService";
import router from "../router";
import _find from "lodash/find";

export default {
  namespaced: true,
  state: {
    _jwt: localStorage.getItem("jwt") || null,
    _user: null
  },
  getters: {
    jwt: state => state._jwt,
    user: state => state._user
  },
  mutations: {
    setJwt: (state, jwt) => (state._jwt = jwt),
    setUser: (state, user) => Vue.set(state, "_user", user),
    setUserPermissions: (state, list) =>
      Vue.set(state._user, "permissions", list)
  },
  actions: {
    async checkMobilePhone({ commit }, payload) {
      await authService.checkMobilePhone(payload);
    },
    async login({ commit }, payload) {
      const tokenResult = await authService.login(payload);
      await authService.storeJwt(tokenResult.data.token);
      commit("setJwt", tokenResult.data.token);
      commit("setUser", tokenResult.data.user);
      commit(
        "user/permissions/setPermissions",
        tokenResult.data.user.permissions,
        {
          root: true
        }
      );
    },
    async logout() {
      await authService.logout();
      window.location.replace("/");
    },
    async loadUser({ commit, getters }) {
      if (getters["user"] === null) {
        const user = await authService.getMe();
        commit("setUser", user.data);
        commit("user/permissions/setPermissions", user.data.permissions, {
          root: true
        });
      }
    }
  }
};
