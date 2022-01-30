import Vue from "vue";
import permissionService from "../../services/permissionService";

export default {
  namespaced: true,
  state: {
    _role_id: null,
    _board_id: null,
    _instance: null
  },
  getters: {
    role_id: state => state._role_id,
    board_id: state => state._board_id,
    instance: state => state._instance
  },
  mutations: {
    setRoleId: (state, id) => (state._role_id = id),
    setBoardId: (state, id) => (state._board_id = id),
    setPermissionsInstance: (state, list) => Vue.set(state, "_instance", list)
  },
  actions: {
    async loadPermissions({ commit, getters }) {
      const instance = await permissionService.loadBoardsPermissions({
        role_id: getters["role_id"],
        board_id: getters["board_id"]
      });
      commit("setPermissionsInstance", instance.data);
    },
    async updateScope({ commit, getters }, payload) {
      const role_id = getters["role_id"];
      const board_id = getters["board_id"];
      const result = await permissionService.updateBoardScope(
        Object.assign({}, payload, { role_id, board_id })
      );
      commit("setPermissionsInstance", result.data);
    }
  }
};
