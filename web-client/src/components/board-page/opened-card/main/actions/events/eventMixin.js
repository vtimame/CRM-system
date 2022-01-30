export default {
  props: {
    event: {
      type: Object,
      required: true
    }
  },
  computed: {
    initiator: function() {
      return this.$store.getters["users/instance"](this.event.initiator_id);
    }
  }
};
