import axios from "axios";

export default {
  async loadUsers() {
    try {
      return await axios.get("users");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadUser(user_id) {
    try {
      return await axios.get(`users/${user_id}`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateUser(user_id, payload) {
    try {
      return await axios.put(`users/${user_id}`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async createUser(user_id, payload) {
    try {
      return await axios.post("users");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadNotifications() {
    try {
      return await axios.get("user/notifications");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async markNotificationAsRead(notification_id) {
    try {
      return await axios.put(`user/notifications/${notification_id}`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async markAllNotificationAsRead(notifications) {
    try {
      return await axios.put(`user/notifications`, { notifications });
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
