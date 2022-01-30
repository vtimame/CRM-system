import Vue from 'vue';

export default {
  namespaced: true,
  state: {
    _httpErrors: [],
  },
  getters: {
    http_errors: (state) => state._httpErrors,
    http_error: (state) => (code) =>
      state._httpErrors.find((el) => el === code),
  },
  mutations: {
    clear_http_errors: (state) => Vue.set(state, '_httpErrors', []),
    set_http_error: (state, error) =>
      Vue.set(state, '_httpErrors', state._httpErrors.concat([error])),
  },
};
