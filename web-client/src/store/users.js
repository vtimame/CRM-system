import Vue from "vue";
import userService from "../services/userService";

export default {
  namespaced: true,
  state: {
    _list: [],
    _loadedInstance: null
  },
  getters: {
    list: state => state._list.filter(el => !el.deleted_at),
    all: state => state._list,
    instance: state => user_id => state._list.find(el => el._id === user_id),
    loadedInstance: state => state._loadedInstance
  },
  mutations: {
    setUsersList: (state, list) => Vue.set(state, "_list", list),
    setUserInstance: (state, user) => Vue.set(state, "_loadedInstance", user)
  },
  actions: {
    async loadUsers({ commit }) {
      const users = await userService.loadUsers();
      commit("setUsersList", users.data);
    },
    async loadUser({ commit }, user_id) {
      const user = await userService.loadUser(user_id);
      commit("setUserInstance", user.data);
    },
    async updateLoadedUser({ commit, getters }, payload) {
      const loadedUser = getters["loadedInstance"];
      const user = await userService.updateUser(loadedUser._id, payload);
      commit("setUserInstance", user.data);
    },
    async createUser({ commit }) {
      const user = await userService.createUser();
      commit("setUserInstance", user.data);
      return user.data;
    }
  }
};
