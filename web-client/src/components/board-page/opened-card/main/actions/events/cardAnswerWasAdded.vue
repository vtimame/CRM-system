<template>
  <div class="subevent">
    <div :style="{ lineHeight: '13px' }">
      <span class="subevent__initiator-name"
        >{{ initiator.surname }} {{ initiator.name }}</span
      >
      <span v-if="comment && comment.user._id !== initiator._id"
        >&nbsp;ответил на комментарий&nbsp;</span
      >
      <span v-else>
        &nbsp;ответил сам себе&nbsp;
      </span>
      <span v-if="!comment" class="subevent__comment-undefined"
        >комментарий не найден</span
      >
      <span
        class="subevent__user-name"
        v-else-if="comment.user._id !== initiator._id"
        >{{ genitive.last }} {{ genitive.first }}</span
      >
    </div>
    <div class="subevent__date">{{ $utils.formatDate(event.created_at) }}</div>
  </div>
</template>

<script>
import eventMixin from "./eventMixin";
const petrovich = require("petrovich");

export default {
  mixins: [eventMixin],
  data: () => ({
    opened: false
  }),
  computed: {
    member: function() {
      return this.$store.getters["users/instance"](this.event.member_id);
    },
    comment: function() {
      return this.$store.getters["kanban/card/actions/comment"](
        this.event.comment_id
      );
    },
    genitive: function() {
      const person = {
        gender: this.comment.user.sex === 1 ? "female" : "male",
        first: this.comment.user.name,
        last: this.comment.user.surname
      };
      return petrovich(person, "accusative");
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.subevent {
  width: 100%;
  position: relative;

  &__initiator-name,
  &__user-name {
    font-weight: 600;
  }

  &__date {
    font-size: 11px;
  }

  &__comment-undefined {
    color: $oc-red-7;
    font-weight: 600;
  }

  &__old-text {
    background-color: $oc-red-1;
    border: 1px solid $oc-red-2;
    padding: 0.5rem;
  }

  &__new-text {
    background-color: $oc-green-1;
    border: 1px solid $oc-green-2;
    padding: 0.5rem;
  }

  &__collapse-btn {
    position: absolute;
    width: 20px;
    height: 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    top: 0;
    right: 0;
  }
}
</style>
