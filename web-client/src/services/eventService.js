import axios from "axios";

export default {
  async loadEvents(card_id) {
    try {
      return await axios.get(`kanban/cards/${card_id}/events`);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async storeEvent(event) {
    try {
      return await axios.post(`kanban/cards/${event.card_id}/events`, event);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  async updateEvent(event) {
    try {
      return await axios.put(
        `kanban/cards/${event.card_id}/events/${event._id}`,
        event
      );
    } catch (e) {
      console.log(e);
      throw e;
    }
  }
};
