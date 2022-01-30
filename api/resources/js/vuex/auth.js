import Vue from 'vue';

export default {
  namespaced: true,
  state: () => ({
    _user: null,
    _token: localStorage.getItem('token') || null,
  }),
  getters: {
    user: (state) => state._user,
    token: (state) => state._token,
  },
  mutations: {
    set_user: (state, instance) => Vue.set(state, '_user', instance),
    set_token: (state, token) => (state._token = token),
  },
  actions: {
    async checkMobilePhone(ctx, mobile_phone) {
      try {
        await this.$axios.get('auth/login', {
          params: { mobile_phone },
        });
      } catch (e) {
        console.log(e.response);
        throw e;
      }
    },
    /**
     * @param {{access_token:string}} data
     * @param payload
     */
    async login({ commit, dispatch }, payload) {
      try {
        const response = await this.$axios.post('auth/login', payload);
        localStorage.setItem('token', response.data.access_token);
        commit('set_token', response.data.access_token);
        await dispatch('loadUser');
      } catch (e) {
        console.log(e.response);
        throw e;
      }
    },
    async loadUser({ commit, getters }) {
      if (getters['user'] !== null) return false;
      try {
        const user = await this.$axios.get('auth/me');
        commit('set_user', user.data);
      } catch (e) {
        console.log(e.response);
        throw e;
      }
    },
    async logout({ commit }) {
      try {
        localStorage.removeItem('token');
        await this.$axios.post('auth/logout');
      } catch (e) {
        console.log(e);
        throw e;
      }
    },
  },
};
