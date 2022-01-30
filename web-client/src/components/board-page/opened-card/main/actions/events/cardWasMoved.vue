<template>
  <div class="subevent">
    <div :style="{ lineHeight: '13px' }">
      <span class="subevent__initiator-name"
        >{{ initiator.surname }} {{ initiator.name }}</span
      >
      <span>&nbsp;перенес карточку из&nbsp;</span>
      <span class="subevent__column-name">{{ old_column.name }}</span>
      <span>&nbsp;в&nbsp;</span>
      <span class="subevent__column-name">{{ new_column.name }}</span>
    </div>
    <div class="subevent__date">{{ $utils.formatDate(event.created_at) }}</div>
  </div>
</template>

<script>
import eventMixin from "./eventMixin";

export default {
  mixins: [eventMixin],
  computed: {
    member: function() {
      return this.$store.getters["users/instance"](this.event.member_id);
    },
    old_column: function() {
      return this.$store.getters["kanban/columns/instance"](
        this.event.old_column_id
      );
    },
    new_column: function() {
      return this.$store.getters["kanban/columns/instance"](
        this.event.new_column_id
      );
    }
  }
};
</script>

<style lang="scss" scoped>
.subevent {
  &__initiator-name,
  &__column-name {
    font-weight: 600;
  }

  &__date {
    font-size: 11px;
  }
}
</style>
