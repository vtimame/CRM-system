import Vue from 'vue';

export default {
  namespaced: true,
  state: {
    _loaded: false,
    _list: [],
  },
  getters: {
    list: (state) => (column_id) =>
      state._list.find((el) => Number(el.id) === Number(column_id)).thumbnails,
    loaded: (state) => state._loaded,
  },
  mutations: {
    set_cards_list: (state, list) => {
      Vue.set(state, '_list', list);
      state._loaded = true;
    },
    set_thumbnails_in_column: (state, { column_id, list }) => {
      const columnIndex = state._list.findIndex(
        (el) => Number(el.id) === Number(column_id)
      );
      Vue.set(state._list[columnIndex], 'thumbnails', list);
    },
    set_loaded_state: (state, new_state) => (state._loaded = new_state),
  },
  actions: {
    async loadColumns({ commit, getters }, board_id) {
      try {
        const list = await this.$axios.get('kanban/columns', {
          params: {
            board_id,
            thumbnails: true,
          },
        });
        commit('set_cards_list', list.data);
      } catch (e) {
        console.log(e);
        throw e;
      }
    },
    async loadThumbnails({ commit }, column_id) {
      try {
        const thumbnails = await this.$axios.get('kanban/thumbnails', {
          params: { column_id },
        });
        commit('set_thumbnails_in_column', {
          column_id,
          list: thumbnails.data,
        });
      } catch (e) {
        console.log(e);
        throw e;
      }
    },
  },
};
