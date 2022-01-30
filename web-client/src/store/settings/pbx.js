import Vue from "vue";
import pbxSettingsService from "../../services/pbxSettingsService";

export default {
  namespaced: true,
  state: {
    _settings: null
  },
  getters: {
    settings: state => state._settings
  },
  mutations: {
    setSettings: (state, instance) => Vue.set(state, "_settings", instance),
    updateSettings: (state, { name, value }) => (state._settings[name] = value)
  },
  actions: {
    async loadSettings({ commit }) {
      try {
        const settings = await pbxSettingsService.loadSettings();
        commit("setSettings", settings.data);
      } catch (e) {
        console.log(e);
      }
    },
    async updateSettings({ commit }, payload) {
      await pbxSettingsService.updateSettings(payload);
      commit("updateSettings", payload);
    }
  }
};
