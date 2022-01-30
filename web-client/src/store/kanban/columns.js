import Vue from "vue";
import columnService from "../../services/columnService";

export default {
  namespaced: true,
  state: {
    _list: [],
    _rawList: []
  },
  getters: {
    list: state => state._list,
    rawList: state => state._rawList,
    instance: state => id => state._list.find(el => el._id === id),
    findByBoardId: state => board_id =>
      state._list.filter(el => el.board_id === board_id),
    findRawByBoardId: state => board_id =>
      state._rawList.filter(el => el.board_id === board_id)
  },
  mutations: {
    setColumnsList: (state, list) => Vue.set(state, "_list", list),
    setRawColumnsList: (state, list) => Vue.set(state, "_rawList", list),
    pushColumn: (state, column) => state._list.push(column)
  },
  actions: {
    async loadColumns({ commit }) {
      const columns = await columnService.loadColumns();
      commit("setColumnsList", columns.data);
    },
    async loadRawColumns({ commit }) {
      const columns = await columnService.loadRawColumns();
      commit("setRawColumnsList", columns.data);
    },
    async update({ commit }, payload) {
      return await columnService.updateColumn(payload);
    },
    async store({ commit }, payload) {
      const column = await columnService.storeColumn(payload);
      commit("pushColumn", payload);
    }
  }
};
