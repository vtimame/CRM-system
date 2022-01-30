import Vue from "vue";
import managerEventsStatsService from "../../services/mangerEventsStatsService";

export default {
  namespaced: true,
  state: {
    _list: []
  },
  getters: {
    list: state => state._list
  },
  mutations: {
    setList: (state, list) => Vue.set(state, "_list", list)
  },
  actions: {
    async loadEvents({ commit }, payload) {
      const list = await managerEventsStatsService.loadEvents(payload);
      commit("setList", list.data);
    }
  }
};
