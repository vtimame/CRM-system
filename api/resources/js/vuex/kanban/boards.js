import Vue from 'vue';

export default {
  namespaced: true,
  state: {
    _list: [],
  },
  getters: {
    list: (state) => state._list,
    instance: (state) => (board_id) =>
      state._list.find((el) => Number(el.id) === Number(board_id)),
  },
  mutations: {
    set_boards_list: (state, list) => Vue.set(state, '_list', list),
  },
  actions: {
    async loadBoards({ commit, getters }) {
      if (getters['list'].length === 0) {
        try {
          const boards = await this.$axios.get('kanban/boards');
          commit('set_boards_list', boards.data);
        } catch (e) {
          console.log(e.response);
          throw e;
        }
      }
    },
  },
};
