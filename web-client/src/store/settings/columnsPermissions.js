import Vue from "vue";
import permissionService from "../../services/permissionService";

export default {
  namespaced: true,
  state: {
    _role_id: null,
    _board_id: null,
    _column_id: null,
    _instance: []
  },
  getters: {
    role_id: state => state._role_id,
    board_id: state => state._board_id,
    column_id: state => state._column_id,
    instance: state => state._instance
  },
  mutations: {
    setRoleId: (state, id) => (state._role_id = id),
    setBoardId: (state, id) => (state._board_id = id),
    setColumnId: (state, id) => (state._column_id = id),
    setPermissionsInstance: (state, instance) =>
      Vue.set(state, "_instance", instance)
  },
  actions: {
    async loadPermissions({ commit, getters }) {
      const role_id = getters["role_id"];
      const board_id = getters["board_id"];
      const column_id = getters["column_id"];
      const instance = await permissionService.loadColumnsPermissions({
        role_id,
        board_id,
        column_id
      });

      commit("setPermissionsInstance", instance.data);
    },
    async updateScope({ commit, getters }, payload) {
      const role_id = getters["role_id"];
      const board_id = getters["board_id"];
      const column_id = getters["column_id"];
      const result = await permissionService.updateColumnScope(
        Object.assign({}, payload, { role_id, board_id, column_id })
      );
      commit("setPermissionsInstance", result.data);
    },
    async updatePermission({ commit, getters }, payload) {
      const role_id = getters["role_id"];
      const board_id = getters["board_id"];
      const column_id = getters["column_id"];
      const result = await permissionService.updateColumnPermission(
        Object.assign(
          {},
          {
            role_id,
            board_id,
            column_id
          },
          payload
        )
      );
      commit("setPermissionsInstance", result.data);
    }
  }
};
