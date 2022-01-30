import Vue from "vue";
import checklistService from "../../../services/checklistService";

export default {
  namespaced: true,
  state: {
    _list: []
  },
  getters: {
    list: state => state._list
  },
  mutations: {
    setList: (state, list) => Vue.set(state, "_list", list),
    pushInList: (state, instance) => state._list.push(instance),
    updateChecklist: (state, instance) => {
      const index = state._list.findIndex(el => el._id === instance._id);
      if (index !== -1) {
        Vue.set(state._list, index, instance);
      }
    }
  },
  actions: {
    async loadChecklists({ commit }, card_id) {
      try {
        const list = await checklistService.loadChecklists(card_id);
        commit("setList", list.data);
      } catch (e) {
        console.log(e.response);
      }
    },
    async storeChecklist({ commit }, payload) {
      try {
        const checklist = await checklistService.storeChecklist(payload);
        commit("pushInList", checklist.data);
      } catch (e) {
        console.log(e.response);
      }
    },
    async updateChecklist({ commit }, payload) {
      try {
        await checklistService.updateChecklist(payload);
        commit("updateChecklist", payload);
      } catch (e) {
        console.log(e.response);
      }
    }
  }
};
