<template>
  <div
    class="oy-action-button"
    :class="{
      'oy-action-button--disabled': disabled,
      'oy-action-button--selected': selected
    }"
    @click="clicked"
  >
    <div v-if="$slots.prefix" class="oy-action-button__prefix">
      <slot name="prefix"></slot>
    </div>
    <div
      class="oy-action-button__content"
      :style="{
        paddingLeft: $slots.prefix ? '0' : '12px',
        paddingRight: $slots.postfix ? '0' : '12px'
      }"
    >
      <slot></slot>
    </div>
    <div v-if="$slots.postfix" class="oy-action-button__postfix">
      <slot name="postfix"></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    disabled: {
      type: Boolean,
      default: false
    },
    selected: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    clicked() {
      if (!this.disabled) this.$emit("click");
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-action-button {
  outline: none;
  color: $oc-gray-8;
  border-radius: 3px;
  text-align: left;
  width: 100%;
  border: none;
  background-color: $oc-gray-3;
  transition: 0.2s;
  margin-bottom: 0.5rem;
  cursor: pointer;
  font-size: 13px;
  display: flex;
  align-items: center;
  user-select: none;

  &:hover {
    background-color: $oc-gray-4;
  }

  &__prefix,
  &__postfix {
    padding: 5px 12px;
  }

  &__content {
    padding: 5px 0;
    flex: 1;
  }

  &--disabled {
    cursor: not-allowed;
    color: $oc-gray-5;
    background-color: $oc-gray-1;

    &:hover {
      background-color: $oc-gray-1;
    }
  }

  &--selected {
    color: white;
    background-color: $oc-green-7;

    &:hover {
      background-color: $oc-green-8;
    }
  }
}
</style>
