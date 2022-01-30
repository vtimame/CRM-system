import Vue from "vue";
import notifications from "./user/notifications";
import permissions from "./user/permissions";
import authService from "../services/authService";
import auth from "./auth";

export default {
  namespaced: true,
  state: {
    _instance: null,
    _token: localStorage.getItem("token") || null,
    _tokens: []
  },
  getters: {
    instance: state => state._instance,
    token: state => state._token,
    tokens: state => state._tokens
  },
  mutations: {
    setUserInstance: (state, user) => Vue.set(state, "_instance", user),
    setToken: (state, token) => (state._token = token),
    setTokensList: (state, list) => Vue.set(state, "_tokens", list)
  },
  actions: {
    async sendPassword({ commit }, login) {
      const user = await authService.sendPassword(login);
      commit("setUserInstance", user.data);
    },
    async logIn({ commit }, payload) {
      const result = await authService.logIn(payload);
      window.localStorage.setItem("token", result.data.token);
      commit("setUserInstance", result.data.user);
      commit("permissions/setPermissions", result.data.permissions);
      commit("setToken", result.data.token);
      commit("setTokensList", result.data.tokens);
    },
    async loadUser({ commit }) {
      const result = await authService.getMe();
      commit("setUserInstance", result.data.user);
      commit("permissions/setPermissions", result.data.permissions);
      commit("setTokensList", result.data.tokens);
    },
    async logout({ getters }) {
      await authService.logout();
      window.localStorage.removeItem("token");
      window.location.replace("/");
    }
  },
  modules: {
    notifications,
    permissions
  }
};
