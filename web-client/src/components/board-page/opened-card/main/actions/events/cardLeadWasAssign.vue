<template>
  <div class="subevent">
    <div :style="{ lineHeight: '13px' }">
      <span class="subevent__initiator-name"
        >{{ initiator.surname }} {{ initiator.name }}</span
      >
      <span>&nbsp;нзначил&nbsp;</span>
      <span class="subevent__lead-name"
        >{{ genitive.last }} {{ genitive.first }}</span
      >
      <span>&nbsp;ведущим карточки</span>
    </div>
    <div class="subevent__date">{{ $utils.formatDate(event.created_at) }}</div>
  </div>
</template>

<script>
import eventMixin from "./eventMixin";
const petrovich = require("petrovich");

export default {
  mixins: [eventMixin],
  computed: {
    lead: function() {
      return this.$store.getters["users/instance"](this.event.lead_id);
    },
    genitive: function() {
      const person = {
        gender: this.lead.sex === 1 ? "female" : "male",
        first: this.lead.name,
        last: this.lead.surname
      };
      return petrovich(person, "accusative");
    }
  }
};
</script>

<style lang="scss" scoped>
.subevent {
  &__initiator-name,
  &__lead-name {
    font-weight: 600;
  }

  &__date {
    font-size: 11px;
  }
}
</style>
