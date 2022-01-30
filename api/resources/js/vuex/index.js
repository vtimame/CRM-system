import Vue from 'vue';
import Vuex from 'vuex';
import app from './app';
import auth from './auth';
import boards from './kanban/boards';
import thumbnails from './kanban/thumbnails';
import card from './kanban/card';

Vue.use(Vuex);

const store = new Vuex.Store({
  state: {},
  getters: {},
  mutations: {},
  actions: {},
  modules: {
    app,
    auth,
    'kanban/boards': boards,
    'kanban/thumbnails': thumbnails,
    'kanban/card': card,
  },
});

export { store };
