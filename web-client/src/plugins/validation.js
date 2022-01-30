import Vuelidate from "vuelidate";

export const cyrillic = value => {
  if (value && value !== null && value.length > 0)
    return /^[\u0400-\u04FF ]+$/.test(value);
  else return Boolean(1);
};

export default {
  install: Vue => {
    Vue.use(Vuelidate);
  }
};
