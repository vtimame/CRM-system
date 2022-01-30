import salesFunnel from "./stats/salesFunnel";
import services from "./stats/services";
import managerEvents from "./stats/managerEvents";

export default {
  namespaced: true,
  modules: {
    salesFunnel,
    services,
    managerEvents
  }
};
