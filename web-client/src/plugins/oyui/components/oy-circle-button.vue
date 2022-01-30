<template>
  <div
    class="oy-circle-button"
    :class="[`oy-circle-button--${color}`]"
    :style="
      Object.assign(
        {},
        { width: `${size}px`, height: `${size}px` },
        customStyle
      )
    "
    @click="$emit('click')"
  >
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: {
    size: {
      type: [String, Number],
      default: 32
    },
    color: {
      type: String,
      default: "gray"
    },
    customStyle: {
      type: Object,
      default: () => {}
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-circle-button {
  border-radius: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  transition: 0.2s;
  cursor: pointer;

  &--gray {
    color: $oc-gray-8;
    background-color: $oc-gray-3;

    &:hover {
      background-color: $oc-gray-4;
    }
  }
}
</style>
