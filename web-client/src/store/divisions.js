import Vue from "vue";
import divisionService from "../services/divisionService";

export default {
  namespaced: true,
  state: {
    _list: []
  },
  getters: {
    list: state => state._list,
    instance: state => id => state._list.find(el => el._id === id)
  },
  mutations: {
    setDivisionsList: (state, list) => Vue.set(state, "_list", list),
    setDivisionInstance: (state, instance) => {
      const index = state._list.findIndex(el => el._id === instance._id);
      if (index !== -1) Vue.set(state._list, index, instance);
    }
  },
  actions: {
    async loadDivisions({ commit }) {
      const list = await divisionService.loadDivisions();
      commit("setDivisionsList", list.data);
    },
    async update({ commit }, { id, payload }) {
      const division = await divisionService.update(id, payload);
      commit("setDivisionInstance", division.data);
    }
  }
};
