<template>
  <div class="subevent">
    <div :style="{ lineHeight: '13px' }">
      <span class="subevent__initiator-name"
        >{{ initiator.surname }} {{ initiator.name }}</span
      >
      <span>&nbsp;добавил новый контакт</span>
    </div>
    <div class="subevent__date">{{ $utils.formatDate(event.created_at) }}</div>
  </div>
</template>

<script>
import eventMixin from "./eventMixin";

export default {
  mixins: [eventMixin],
  data: () => ({
    opened: false
  })
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
