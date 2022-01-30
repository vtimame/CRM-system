import Vue from "vue";
import salesFunnelService from "@/services/salesFunnelService";
import servicesStatsService from "@/services/servicesStatsService";

export default {
  namespaced: true,
  state: {
    _cards: []
  },
  getters: {
    cards: state => state._cards
  },
  mutations: {
    setCards: (state, list) => Vue.set(state, "_cards", list)
  },
  actions: {
    async loadCards({ commit }, payload) {
      const list = await servicesStatsService.loadCards(payload);
      commit("setCards", list.data);
    }
  }
};
