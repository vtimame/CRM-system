import Vue from "vue";
import userService from "../../services/userService";

export default {
  namespaced: true,
  state: {
    _list: []
  },
  getters: {
    list: state => state._list,
    notRead: state => state._list.filter(el => !el.read_at)
  },
  mutations: {
    setNotificationsList: (state, list) => {
      Vue.set(state, "_list", list);
    },
    setNotificationInstance: (state, instance) => {
      const index = state._list.findIndex(el => el._id === instance._id);
      Vue.set(state._list, index, instance);
    },
    unshiftNotification: (state, instance) => state._list.unshift(instance)
  },
  actions: {
    async loadNotifications({ commit }) {
      const notifications = await userService.loadNotifications();
      commit("setNotificationsList", notifications.data);
    },
    async markAsRead({ commit }, notification_id) {
      const notification = await userService.markNotificationAsRead(
        notification_id
      );
      commit("setNotificationInstance", notification.data);
    },
    async markAllAsRead({ commit }, notification_ids = null) {
      const notifications = await userService.markAllNotificationAsRead(
        notification_ids
      );
      commit("setNotificationsList", notifications.data);
    }
  }
};
