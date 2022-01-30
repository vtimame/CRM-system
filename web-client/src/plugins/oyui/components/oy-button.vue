<template>
  <button
    class="btn btn-sm"
    :class="[`btn-${type}`, { 'btn-block': block }]"
    @click="$emit('click')"
    :type="htmlType"
    :disabled="disabled"
    :style="{ fontWeight: fontWeight }"
  >
    <slot></slot>
  </button>
</template>

<script>
export default {
  props: {
    htmlType: {
      type: String,
      default: "button"
    },
    type: {
      type: String,
      default: "success"
    },
    disabled: {
      type: Boolean,
      default: false
    },
    block: {
      type: Boolean,
      default: false
    },
    fontWeight: {
      type: Number,
      default: 500
    }
  }
};
</script>

<style lang="scss" scoped>
.btn {
  &:focus {
    box-shadow: none;
  }
}
</style>
