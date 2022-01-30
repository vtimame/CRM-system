import axios from "axios";

export default {
  async loadCards(board_id) {
    try {
      return await axios.get("kanban/cards", { params: { board_id } });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async autoAddMembers(card_id) {
    try {
      return await axios.post(`kanban/cards/${card_id}/autoaddMembers`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async createMoveEvent(payload) {
    try {
      return await axios.post(
        `kanban/cards/${payload.card_id}/createMoveEvent`,
        {
          old_column_id: payload.old_column_id,
          new_column_id: payload.new_column_id
        }
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadRawCards() {
    try {
      return await axios.get("kanban/raw/cards");
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async loadCard(card_id) {
    try {
      return await axios.get(`kanban/cards/${card_id}`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeCard(instance) {
    try {
      return await axios.post("kanban/cards", instance);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async deleteCard(id) {
    try {
      return await axios.delete(`kanban/cards/${id}`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateCard(card_id, payload) {
    try {
      return await axios.put(`kanban/cards/${card_id}`, payload);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async sendCreatorNotification(card_id, payload) {
    try {
      return await axios.post(
        `kanban/cards/${card_id}/creator-notification`,
        payload
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateCardAddress(card_id, address) {
    try {
      return await axios.put(`kanban/cards/${card_id}/address`, address);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeCardContact(card_id, contact) {
    try {
      return await axios.post(`kanban/cards/${card_id}/contact`, contact);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async deleteCardContact(card_id, contact_id) {
    try {
      return await axios.delete(
        `kanban/cards/${card_id}/contact/${contact_id}`
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateCardContact(card_id, contact) {
    try {
      return await axios.put(
        `kanban/cards/${card_id}/contact/${contact._id}`,
        contact
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateManagerProfile(card_id, payload) {
    try {
      return await axios.put(
        `kanban/cards/${card_id}/manager-profile`,
        payload
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateExploringProfile(card_id, payload) {
    try {
      return await axios.put(
        `kanban/cards/${card_id}/exploring-profile`,
        payload
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateCardClient(card_id, client) {
    try {
      return await axios.put(`kanban/cards/${card_id}/client`, client);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateCardOperator(card_id, operator) {
    try {
      return await axios.put(`kanban/cards/${card_id}/operator`, operator);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async deleteCardAttachment(card_id, attachment_id) {
    try {
      return await axios.delete(
        `kanban/cards/${card_id}/attachments/${attachment_id}`
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async addMember(card_id, user_id) {
    try {
      return await axios.post(`kanban/cards/${card_id}/members`, { user_id });
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async deleteMember(card_id, user_id) {
    try {
      return await axios.delete(`kanban/cards/${card_id}/members/${user_id}`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
