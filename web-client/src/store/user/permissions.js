import Vue from "vue";
import _find from "lodash/find";

export default {
  namespaced: true,
  state: {
    _system: null,
    _boards: [],
    _columns: []
  },
  getters: {
    systemScope: state => state._system?.scope,
    boardScope: state => id => _find(state._boards, { board_id: id })?.scope,
    columnScope: state => ({ board_id, column_id }) =>
      _find(state._columns, {
        board_id: board_id,
        column_id: column_id
      })?.scope,
    columnPermissions: state => ({ board_id, column_id }) =>
      _find(state._columns, {
        board_id: board_id,
        column_id: column_id
      })
  },
  mutations: {
    setPermissions: (state, payload) => {
      Vue.set(state, "_system", payload.system);
      Vue.set(state, "_boards", payload.boards);
      Vue.set(state, "_columns", payload.columns);
    }
  }
};
