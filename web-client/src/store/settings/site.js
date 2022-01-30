import Vue from "vue";
import SiteSettingsService from "../../services/SiteSettingsService";

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
        const settings = await SiteSettingsService.loadSettings();
        commit("setSettings", settings.data);
      } catch (e) {
        console.log(e);
      }
    },
    async updateSettings({ commit }, payload) {
      const result = await SiteSettingsService.updateSettings(payload);
      commit("setSettings", result.data);
    }
  }
};
