import axios from "axios";

export default {
  async loadAutoaddList(column_id) {
    try {
      return await axios.get(`kanban/columns/${column_id}/autoadd`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async addRole(column_id, role_id) {
    try {
      return await axios.post(`kanban/columns/${column_id}/autoadd`, {
        role_id
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async deleteRole(column_id, role_id) {
    try {
      return await axios.delete(`kanban/columns/${column_id}/autoadd`, {
        params: { role_id }
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
