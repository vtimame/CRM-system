<template>
  <div
    class="settings d-flex flex-column"
    :class="{ 'settings--opened': isOpened }"
  >
    <div
      class="settings__header d-flex justify-content-between align-items-center"
    >
      <div class="settings__title">{{ title }}</div>
      <div :style="{ cursor: 'pointer' }" @click="$emit('close')">
        <oy-feather-icon type="x" size="18" :style="{ marginTop: '-3px' }" />
      </div>
    </div>
    <div class="settings__content flex-grow-1">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: "sales-funnel-settings",
  props: {
    isOpened: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      required: true
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

$width: 350px;

.settings {
  width: $width;
  position: absolute;
  top: 0;
  right: -$width;
  bottom: 0;
  background-color: white;
  color: $oc-gray-8;
  transition: 0.25s ease-in-out;

  &__header {
    padding: 0.5rem 1rem;
    border-bottom: 1px solid $oc-gray-3;
  }

  &__content {
    padding: 0.5rem 1rem;
  }

  &__title {
    font-weight: 600;
  }

  &--opened {
    right: 0;
  }
}
</style>
