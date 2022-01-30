import Vue from "vue";
import cardService from "../../services/cardService";
import _set from "lodash/set";
import _uniq from "lodash/uniq";
import attachmentService from "../../services/attachmentService";
import memberService from "../../services/memberService";

export default {
  namespaced: true,
  state: {
    _search_value: "",
    _selected_creator: null,
    _board_id: null,
    _list: [],
    _rawList: []
  },
  getters: {
    list: state => state._list,
    rawList: state => state._rawList,
    board_id: state => state._board_id,
    selected_creator: state => state._selected_creator,
    search_value: state => state._search_value,
    boardCards: state => ({ board_id }) =>
      state._list.filter(el => el.board_id === board_id),
    columnCards: state => ({ board_id, column_id }) =>
      state._list.filter(
        el => el.column_id === column_id && el.board_id === board_id
      ),
    instance: state => id => state._list.find(el => el._id === id),
    rawInstance: state => id => state._rawList.find(el => el._id === id),
    creators: state => {
      return _uniq(state._list.map(el => el.creator_id));
    }
  },
  mutations: {
    setSearchValue: (state, value) => (state._search_value = value),
    setBoardId: (state, value) => (state._board_id = value),
    setSelectedId: (state, id) => (state._selected_creator = id),
    setCardsList: (state, cards) => Vue.set(state, "_list", cards),
    setRawCardsList: (state, cards) => Vue.set(state, "_rawList", cards),
    setCardData: (state, { card_id, payload }) => {
      const key = Object.keys(payload)[0];
      const value = Object.values(payload)[0];
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        const card = state._list[cardIndex];
        Vue.set(state._list, cardIndex, _set(card, key, value));
      }
    },
    pushContact: (state, { card_id, contact }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        const card = state._list[cardIndex];
        if (!card.contacts)
          Vue.set(state._list[cardIndex], "contacts", [contact]);
        else
          Vue.set(
            state._list[cardIndex],
            "contacts",
            state._list[cardIndex].contacts.concat([contact])
          );
      }
    },
    updateContact: (state, { card_id, contact }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        const contactIndex = state._list[cardIndex].contacts.findIndex(
          el => el._id === contact._id
        );
        if (contactIndex !== 1) {
          Vue.set(state._list[cardIndex].contacts, contactIndex, contact);
        }
      }
    },
    deleteContact: (state, { card_id, contact_id }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        const contactIndex = state._list[cardIndex].contacts.findIndex(
          el => el._id === contact_id
        );
        if (contactIndex !== -1) {
          state._list[cardIndex].contacts.splice(contactIndex, 1);
        }
      }
    },
    pushAttachment: (state, { card_id, attachment_id }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        if (!state._list[cardIndex].attachments) {
          Vue.set(state._list[cardIndex], "attachments", [attachment_id]);
        } else state._list[cardIndex].attachments.push(attachment_id);
      }
    },
    setCover: (state, { card_id, attachment }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        Vue.set(state._list[cardIndex], "cover", attachment);
      }
    },
    deleteAttachment: (state, { card_id, attachment_id }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        if (state._list[cardIndex].attachments) {
          const attachmentIndex = state._list[cardIndex].attachments.findIndex(
            el => el === attachment_id
          );
          if (attachmentIndex !== -1)
            state._list[cardIndex].attachments.splice(attachmentIndex, 1);
        }
      }
    },
    pushMember: (state, { card_id, member_id }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        state._list[cardIndex].members.push(member_id);
      }
    },
    deleteMember: (state, { card_id, member_id }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        if (state._list[cardIndex].members) {
          const memberIndex = state._list[cardIndex].members.findIndex(
            el => el === member_id
          );
          if (memberIndex !== -1)
            state._list[cardIndex].members.splice(memberIndex, 1);
        }
      }
    },
    setMembers: (state, { card_id, list }) => {
      const cardIndex = state._list.findIndex(el => el._id === card_id);
      if (cardIndex !== -1) {
        Vue.set(state._list[cardIndex], "members", list);
      }
    },
    pushCard: (state, instance) => {
      state._list.unshift(instance);
    },
    deleteCard: (state, id) => {
      Vue.set(
        state,
        "_list",
        state._list.filter(el => el._id !== id)
      );
    }
  },
  actions: {
    async loadRawCards({ commit }) {
      const cards = await cardService.loadRawCards();
      commit("setRawCardsList", cards.data);
    },
    async loadCards({ commit }, board_id) {
      const cards = await cardService.loadCards(board_id);
      commit("setCardsList", cards.data);
      commit("setBoardId", board_id);
    },
    async pushAttachment({ commit }, { card_id, instance }) {
      commit("pushAttachment", { card_id, attachment_id: instance._id });
      commit("kanban/card/attachments/pushAttachment", instance, {
        root: true
      });
    },
    async deleteAttachment({ commit }, { card_id, instance }) {
      await attachmentService.deleteAttachment(card_id, instance._id);
      commit("deleteAttachment", { card_id, attachment_id: instance._id });
      commit("kanban/card/attachments/deleteAttachment", instance, {
        root: true
      });
    },
    async addMember({ commit }, { card_id, member_id }) {
      await memberService.pushMember(card_id, member_id);
      commit("pushMember", { card_id, member_id });
    },
    async deleteMember({ commit }, { card_id, member_id }) {
      await memberService.pullMember(card_id, member_id);
      commit("deleteMember", { card_id, member_id });
    },
    async addCard({ commit }, payload) {
      const card = await cardService.storeCard(payload);
      commit("pushCard", card.data);
    },
    async deleteCard({ commit }, id) {
      await cardService.deleteCard(id);
      commit("deleteCard", id);
    },
    async autoAddMembers({ commit }, card_id) {
      const members = await cardService.autoAddMembers(card_id);
      commit("setMembers", { card_id, list: members.data });
      return members.data;
    },
    async createMoveEvent({ commit }, payload) {
      await cardService.createMoveEvent(payload);
    }
  }
};
