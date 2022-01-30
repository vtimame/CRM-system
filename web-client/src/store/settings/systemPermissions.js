import Vue from "vue";
import permissionService from "../../services/permissionService";

export default {
  namespaced: true,
  state: {
    _role_id: null,
    _instance: null
  },
  getters: {
    role_id: state => state._role_id,
    instance: state => state._instance
  },
  mutations: {
    setRoleId: (state, id) => (state._role_id = id),
    setPermissionsInstance: (state, instance) =>
      Vue.set(state, "_instance", instance)
  },
  actions: {
    async loadPermissions({ commit, getters }) {
      const role_id = getters["role_id"];
      const instance = await permissionService.loadSystemPermissions({
        role_id
      });
      commit("setPermissionsInstance", instance.data);
    },
    async updateScope({ commit, getters }, payload) {
      const role_id = getters["role_id"];
      const result = await permissionService.updateSystemScope(
        Object.assign({}, { role_id }, payload)
      );
      commit("setPermissionsInstance", result.data);
    }
  }
};
