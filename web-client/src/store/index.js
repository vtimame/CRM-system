import Vue from "vue";
import Vuex from "vuex";
import app from "./app";
import auth from "./auth";
import roles from "./roles";
import divisions from "./divisions";
import users from "./users";
import permissions from "./permissions";
// import user modules
import user from "./user";
// import kanban modules
import kanban from "./kanban";
// import settings modules
import settingsSystemPermissions from "./settings/systemPermissions";
import settingsBoardsPermissions from "./settings/boardsPermissions";
import settingsColumnsPermissions from "./settings/columnsPermissions";
// import vuex plugins
import { cardUpdatePlugin } from "./plugins/cardUpdatePlugin";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {},
  mutations: {},
  actions: {},
  modules: {
    app,
    auth,
    roles,
    divisions,
    users,
    permissions,
    user,
    kanban,
    "settings/systemPermissions": settingsSystemPermissions,
    "settings/boardsPermissions": settingsBoardsPermissions,
    "settings/columnsPermissions": settingsColumnsPermissions
  },
  plugins: [cardUpdatePlugin]
});
