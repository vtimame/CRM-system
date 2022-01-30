import Vue from "vue";
import phonebookService from "@/services/phonebookService";

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
    async loadList({ commit }) {
      const list = await phonebookService.loadPhonebook();
      commit("setList", list.data);
    }
  }
};
