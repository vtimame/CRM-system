import axios from "axios";

export default {
  async loadSystemPermissions({ role_id }) {
    try {
      return await axios.get(`roles/${role_id}/system-permissions`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadBoardsPermissions({ role_id, board_id }) {
    try {
      return await axios.get(`roles/${role_id}/boards-permissions`, {
        params: { board_id }
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadColumnsPermissions({ role_id, board_id, column_id }) {
    try {
      return await axios.get(`roles/${role_id}/columns-permissions`, {
        params: { board_id, column_id }
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateSystemScope(payload) {
    try {
      return await axios.post(`roles/${payload.role_id}/system-scope`, {
        scope: payload.scope,
        remove: payload.remove
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateBoardScope(payload) {
    try {
      return await axios.post(`roles/${payload.role_id}/board-scope`, {
        scope: payload.scope,
        remove: payload.remove,
        board_id: payload.board_id
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateColumnScope(payload) {
    try {
      return await axios.post(`roles/${payload.role_id}/column-scope`, {
        scope: payload.scope,
        remove: payload.remove,
        board_id: payload.board_id,
        column_id: payload.column_id
      });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateColumnPermission(payload) {
    try {
      return await axios.put(
        `roles/${payload.role_id}/columns-permissions`,
        payload
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
