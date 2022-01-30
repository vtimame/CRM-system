import Vue from "vue";
import _find from "lodash/find";
import roleService from "../services/roleService";
import permissionService from "../services/permissionService";

export default {
  namespaced: true,
  state: {
    _list: []
  },
  getters: {
    list: state => state._list,
    instance: state => role_id => state._list.find(el => el._id === role_id),
    permission: state => (name, role_id) => {
      const role = _find(state._list, { id: role_id });
      if (!role) return Boolean(0);
      return _find(role.global_permissions, { name, role_id });
    },
    boardPermission: state => (name, role_id, board_id) => {
      const role = _find(state._list, { id: role_id });
      if (!role) return Boolean(0);
      return _find(role.column_permissions, { name, role_id, board_id });
    },
    columnPermission: state => (name, role_id, column_id) => {
      const role = _find(state._list, { id: role_id });
      if (!role) return Boolean(0);
      return _find(role.column_permissions, { name, role_id, column_id });
    }
  },
  mutations: {
    setRolesList: (state, list) => Vue.set(state, "_list", list),
    addPermission: (state, { permission, role_id }) => {
      const role = _find(state._list, { id: role_id });
      if (role)
        Vue.set(role, "permissions", role.permissions.concat([permission]));
    },
    setPermissions: (state, { role_id, permissions }) => {
      const role = _find(state._list, { id: role_id });
      if (role) {
        Vue.set(role, "permissions", permissions);
      }
    }
  },
  actions: {
    async loadRoles({ commit, getters }) {
      if (getters["list"].length === 0) {
        const roles = await roleService.loadRoles();
        commit("setRolesList", roles.data);
      }
    },
    async changePermission({ commit }, payload) {
      if (payload.value === true) {
        const result = await permissionService.addPermission(payload);
        commit("addPermission", {
          permission: result.data,
          role_id: payload.role_id
        });
      } else if (payload.value === false) {
        const permissions = await permissionService.deletePermission(
          payload._id
        );
        commit("setPermissions", {
          role_id: payload.role_id,
          permissions: permissions.data
        });
      }
    }
  }
};
