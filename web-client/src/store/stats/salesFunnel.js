import Vue from "vue";
import salesFunnelService from "@/services/salesFunnelService";

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
      const list = await salesFunnelService.loadCards(payload);
      commit("setCards", list.data);
    }
  }
};
