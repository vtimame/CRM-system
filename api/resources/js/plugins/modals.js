import Vue from 'vue';

export const $modal = new Vue({
  name: '$modal',
  methods: {
    open(options) {
      this.$emit('open', options);
    },
    close(options) {
      this.$emit('close', options);
    },
  },
});

export const Modals = {
  install: (Vue) => {
    Vue.prototype.$modal = $modal;
  },
};
