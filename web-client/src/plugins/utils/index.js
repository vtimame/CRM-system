import moment from "moment";

const formatPhone = string => {
  let phone = string.split("");
  const mask = {
    0: "+7 (",
    3: ") ",
    6: "-",
    8: "-"
  };

  phone.forEach((el, i) => {
    if (mask[i]) phone[i] = mask[i] + el;
  });

  return phone.join("");
};

const formatDate = date => moment(date).format("DD.MM.YYYY HH:mm:ss");

export default {
  install: Vue => {
    Vue.prototype.$utils = {
      formatDate,
      formatPhone
    };
  }
};
