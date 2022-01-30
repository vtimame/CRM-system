import Vue from "vue";
import permissionService from "../services/permissionService";
import _find from "lodash/find";
import _findIndex from "lodash/findIndex";

export default {
  namespaced: true,
  state: {
    _current_column_id: null,
    _current_board_id: null,
    _current_role_id: null,
    _list: []
  },
  getters: {
    current_role_id: state => state._current_role_id,
    current_board_id: state => state._current_board_id,
    current_column_id: state => state._current_column_id,
    list: state => state._list,
    instance: state => payload => {
      let name;
      let board_id;
      let column_id;

      if (typeof payload === "string") {
        name = payload;
        column_id = state._current_column_id;
        board_id = state._current_board_id;
      } else if (typeof payload === "object") {
        name = payload.name;
        column_id = payload.column_id;
        board_id = payload.board_id;
      } else return Boolean(0);

      let conditions = {
        name
      };

      if (column_id) conditions.column_id = column_id;
      if (board_id) conditions.board_id = board_id;

      return _find(state._list, conditions);
    }
  },
  mutations: {
    setCurrentRoleId: (state, role_id) => {
      state._current_role_id = role_id;
    },
    setCurrentColumnId: (state, column_id) => {
      state._current_column_id = column_id;
    },
    setCurrentBoardId: (state, board_id) => {
      state._current_board_id = board_id;
    },
    setPermissions: (state, list) => {
      Vue.set(state, "_list", list);
    },
    pushPermission: (state, permission) => {
      const newList = state._list.concat([permission]);
      Vue.set(state, "_list", newList);
    },
    deletePermission: (state, id) => {
      const index = _findIndex(state._list, { id });
      state._list.splice(index, 1);
    }
  },
  actions: {
    async setCurrentColumnId({ commit }, column_id) {
      commit("setCurrentColumnId", column_id);
    },
    async setCurrentRoleId({ commit }, role_id) {
      commit("setCurrentRoleId", role_id);
    },
    async loadPermissions({ commit, getters }) {
      const permissions = await permissionService.loadPermissions({
        role_id: getters["current_role_id"],
        column_id: getters["current_column_id"],
        board_id: getters["current_board_id"]
      });
      commit("setPermissions", permissions.data);
    },
    async addPermission({ commit, getters }, payload) {
      console.log(payload);
      const permissions = await permissionService.addPermission(
        Object.assign({}, payload, { role_id: getters["current_role_id"] })
      );
      commit("setPermissions", permissions.data);
    },
    async deletePermission({ commit, getters }, payload) {
      const permissions = await permissionService.deletePermission(
        Object.assign({}, payload, { role_id: getters["current_role_id"] })
      );
      commit("setPermissions", permissions.data);
    }
  }
};
