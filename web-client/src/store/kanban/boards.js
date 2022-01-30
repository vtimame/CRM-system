import Vue from "vue";
import boardService from "../../services/boardService";
import columnService from "../../services/columnService";
import _flatten from "lodash/flatten";
import _unset from "lodash/unset";

export default {
  namespaced: true,
  state: {
    _list: [],
    _raw_list: [],
    _subscribers: []
  },
  getters: {
    list: state => state._list,
    raw_list: state => state._raw_list,
    instance: state => board_id => state._list.find(el => el._id === board_id),
    rawInstanceByName: state => name =>
      state._raw_list.find(el => el.name === name)
  },
  mutations: {
    setBoardsList: (state, list) => Vue.set(state, "_list", list),
    setRawBoardsList: (state, list) => Vue.set(state, "_raw_list", list),
    pushColumn: (state, column) => {
      const index = state._list.findIndex(el => el._id === column.board_id);
      if (index !== -1) {
        state._list[index].columns.push(column);
      }
    },
    pushBoard: (state, board) => {
      state._list.push(board);
    },
    updateBoardData: (state, payload) => {
      const { board_id } = payload;
      const board = state._list.find(el => el._id === board_id);
      if (board) {
        Object.keys(payload).forEach(key => {
          if (key !== "board_id") board[key] = payload[key];
        });
      }
    },
    updateColumnData: (state, payload) => {
      const { board_id, column_id } = payload;
      const board = state._list.find(el => el._id === board_id);
      if (board) {
        const column = board.columns.find(el => el._id === column_id);
        if (column) {
          Object.keys(payload).forEach(key => {
            if (key !== "board_id" && key !== "column_id")
              column[key] = payload[key];
          });
        }
      }
    }
  },
  actions: {
    async loadBoards({ commit, getters }) {
      const boards = await boardService.loadBoards();
      commit("setBoardsList", boards.data);
    },
    async loadRawBoards({ commit, getters }) {
      const boards = await boardService.loadRawBoards();
      commit("setRawBoardsList", boards.data);
    },
    async storeBoard({ commit }, name) {
      const board = await boardService.storeBoard(name);
      commit("pushBoard", board.data);
      return board.data;
    },
    async updateBoard({ commit }, payload) {
      const result = await boardService.updateBoard(payload);
      commit("updateBoardData", result.data);
    },
    async updateColumn({ commit }, payload) {
      const result = await columnService.updateColumn(payload);
      commit("updateColumnData", result.data);
      commit("kanban/columns/updateColumnData", result.data, { root: true });
    },
    async loadThumbnails({ commit }, payload) {
      console.log(payload);
    }
  }
};
