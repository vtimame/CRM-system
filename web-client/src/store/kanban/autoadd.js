import Vue from "vue";
import autoaddService from "../../services/autoaddService";

export default {
  namespaced: true,
  state: {
    _column_id: null,
    _list: []
  },
  getters: {
    column_id: state => state._column_id,
    list: state => state._list,
    instance: state => initiator_id =>
      state._list.find(el => el.role_id === initiator_id)
  },
  mutations: {
    setColumnId: (state, column_id) => (state._column_id = column_id),
    setList: (state, list) => Vue.set(state, "_list", list),
    pushInitiator: (state, { initiator_id, getters }) => {
      const instance = getters["instance"](initiator_id);
      if (!instance) {
        state._list.push({
          role_id: initiator_id,
          roles: []
        });
      }
    },
    pushRole: (state, id) => {
      state._list.push(id);
    },
    deleteRole: (state, id) => {
      const index = state._list.indexOf(id);
      if (index !== -1) state._list.splice(index, 1);
    }
  },
  actions: {
    async loadAutoaddList({ commit }, column_id) {
      commit("setColumnId", column_id);
      const list = await autoaddService.loadAutoaddList(column_id);
      commit("setList", list.data);
    },
    async addRole({ commit, getters }, id) {
      await autoaddService.addRole(getters["column_id"], id);
      commit("pushRole", id);
    },
    async deleteRole({ commit, getters }, id) {
      await autoaddService.deleteRole(getters["column_id"], id);
      commit("deleteRole", id);
    }
  }
};
