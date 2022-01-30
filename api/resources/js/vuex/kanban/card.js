export default {
  namespaced: true,
  state: {
    _instance: null,
  },
  getters: {
    instance: (state) => state._instance,
  },
  mutations: {
    set_card_instance: (state, instance) => (state._instance = instance),
  },
  actions: {
    async loadCard({ commit, getters }, card_id) {
        const instance = getters['instance']
      try {
        if (instance !== null && Number(instance.id) === Number(card_id)) return false;
          const card = await this.$axios.get(`kanban/cards/${card_id}`);
          commit('set_card_instance', card.data);
      } catch (e) {
        console.log(e);
        throw e;
      }
    },
  },
};
