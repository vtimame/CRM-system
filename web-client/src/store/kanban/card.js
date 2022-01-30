import Vue from "vue";
import events from "./card/events";
import attachments from "./card/attachments";
import checklists from "./card/checklists";

export default {
  namespaced: true,
  state: {
    _subscribers: []
  },
  getters: {
    subscribers: state => state._subscribers
  },
  mutations: {
    setSubscribers: (state, list) => Vue.set(state, "_subscribers", list),
    pushSubscriber: (state, user) => state._subscribers.push(user),
    deleteSubscriber: (state, user_id) => {
      const index = state._subscribers.findIndex(el => el._id === user_id);
      if (index !== -1) state._subscribers.splice(index, 1);
    }
  },
  modules: {
    events,
    attachments,
    checklists
  }
};
