import Vue from "vue";
import settingsService from "@/services/settingsService";

export default {
  namespaced: true,
  state: {
    _instance: null
  },
  getters: {
    instance: state => state._instance
  },
  mutations: {
    setInstance: (state, instance) => Vue.set(state, "_instance", instance)
  },
  actions: {
    async loadSettingsInstance({ commit }) {
      const instance = await settingsService.loadSettings();
      commit("setInstance", instance.data);
    },
    async updateSettingsInstance({ commit }, payload) {
      const instance = await settingsService.updateSettings(payload);
      commit("setInstance", instance.data);
    }
  }
};
