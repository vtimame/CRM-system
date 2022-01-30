import Vue from "vue";
import attachmentService from "../../../services/attachmentService";

export default {
  namespaced: true,
  state: {
    _list: []
  },
  getters: {
    list: state => state._list,
    instance: state => id => state._list.find(el => el._id === id)
  },
  mutations: {
    setAttachmentsList: (state, list) => Vue.set(state, "_list", list),
    pushAttachment: (state, instance) => state._list.push(instance),
    updateAttachment: (state, attachment) => {
      const index = state._list.findIndex(el => el._id === attachment._id);
      if (index !== -1) {
        Vue.set(state._list, index, attachment);
      }
    },
    deleteAttachment: (state, instance) => {
      const index = state._list.find(el => el._id === instance._id);
      if (index !== -1) state._list.splice(index, 1);
    }
  },
  actions: {
    async loadAttachments({ commit }, ids) {
      const list = await attachmentService.loadAttachments(ids);
      commit("setAttachmentsList", list.data);
    }
  }
};
