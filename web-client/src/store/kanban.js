import boards from "./kanban/boards";
import columns from "./kanban/columns";
import cards from "./kanban/cards";
import card from "./kanban/card";

export default {
  namespaced: true,
  modules: {
    boards,
    columns,
    cards,
    card
  }
};
