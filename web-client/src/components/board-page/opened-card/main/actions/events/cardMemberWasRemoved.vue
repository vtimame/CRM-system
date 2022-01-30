<template>
  <div class="subevent">
    <div :style="{ lineHeight: '13px' }">
      <span class="subevent__initiator-name"
        >{{ initiator.surname }} {{ initiator.name }}</span
      >
      <span>&nbsp;исключил&nbsp;</span>
      <span class="subevent__member-name"
        >{{ genitive.last }} {{ genitive.first }}</span
      >
      <span>&nbsp;из карточки</span>
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
    member: function() {
      return this.$store.getters["users/instance"](this.event.member_id);
    },
    genitive: function() {
      const person = {
        gender: this.member.sex === 1 ? "female" : "male",
        first: this.member.name,
        last: this.member.surname
      };
      return petrovich(person, "accusative");
    }
  }
};
</script>

<style lang="scss" scoped>
.subevent {
  &__initiator-name,
  &__member-name {
    font-weight: 600;
  }

  &__date {
    font-size: 11px;
  }
}
</style>
