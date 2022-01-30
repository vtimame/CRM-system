import _find from "lodash/find";

const permissions = {
  permission(list, name) {
    return _find(list, {
      board_id: null,
      column_id: null,
      name
    });
  },
  boardPermission(list, name, board_id) {
    return _find(list, {
      board_id,
      column_id: null,
      name
    });
  },
  columnPermission(list, name, board_id, column_id) {
    return _find(list, {
      board_id,
      column_id,
      name
    });
  },
  can(list, name) {
    return this.permission(list, name) !== undefined;
  },
  canInBoard(list, name, board_id) {
    return this.boardPermission(list, name, board_id) !== undefined;
  },
  canInColumn(list, name, board_id, column_id) {
    return this.columnPermission(list, name, board_id, column_id) !== undefined;
  }
};

export default {
  install: Vue => {
    Vue.prototype.$permissions = permissions;
  }
};
