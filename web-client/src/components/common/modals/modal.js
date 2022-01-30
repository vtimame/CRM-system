import wrapper from "./wrapper";
export default {
  props: {
    options: {
      type: Object,
      required: true
    }
  },
  components: {
    wrapper
  },
  methods: {
    close() {
      this.$modal.close(this.options.name);
    }
  }
};
