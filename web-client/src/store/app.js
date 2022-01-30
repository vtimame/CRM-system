import Vue from "vue";
import pbx from "./settings/pbx";
import site from "./settings/site";
import phonebook from "./phonebook";
import settings from "./app/settings";
import stats from "./stats";

export default {
  namespaced: true,
  state: {
    _httpErrorCode: null,
    _validateErrors: {}
  },
  getters: {
    httpErrorCode: state => state._httpErrorCode,
    validateError: state => key => state._validateErrors[key]
  },
  mutations: {
    clearHttpError: state => (state._httpErrorCode = null),
    setHttpErrorCode: (state, code) => (state._httpErrorCode = code),
    clearValidateErrors: state => Vue.set(state, "_validateErrors", {}),
    pushValidateError: (state, { key, message }) => {
      Vue.set(
        state,
        "_validateErrors",
        Object.assign({}, state._validateErrors, { [key]: message })
      );
    }
  },
  modules: {
    pbx,
    site,
    phonebook,
    settings,
    stats
  }
};
