import Vue from "vue";
import eventService from "../../../services/eventService";

export default {
  namespaced: true,
  state: {
    _list: []
  },
  getters: {
    list: state => state._list
  },
  mutations: {
    setEventsList: (state, list) => Vue.set(state, "_list", list),
    pushEvent: (state, event) => state._list.push(event),
    pushChildEvent: (state, event) => {
      const parent = state._list.findIndex(el => el._id === event.parent_id);
      if (parent !== -1) state._list[parent].children.push(event);
    },
    updateEvent: (state, event) => {
      const parent = state._list.findIndex(el => el._id === event._id);
      if (parent !== -1) Vue.set(state._list, parent, event);
    }
  },
  actions: {
    async loadEvents({ commit }, card_id) {
      const events = await eventService.loadEvents(card_id);
      commit("setEventsList", events.data);
    },
    async storeEvent({ commit }, event) {
      const result = await eventService.storeEvent(event);
      if (!result.data.parent_id) commit("pushEvent", result.data);
      else commit("pushChildEvent", result.data);
      return result;
    },
    async updateEvent({ commit }, event) {
      await eventService.updateEvent(event);
      commit("updateEvent", event);
    }
  }
};
