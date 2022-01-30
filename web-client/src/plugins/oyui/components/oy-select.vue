<template>
  <select
    class="oy-select form-control form-control-sm"
    :value="value"
    @change="$emit('change', $event.target.value)"
    @input="$emit('input', $event.target.value)"
  >
    <option
      disabled="disabled"
      value=""
      :selected="value === '' || value === undefined"
      >{{ disabledOption }}</option
    >
    <slot></slot>
  </select>
</template>

<script>
export default {
  props: {
    value: {
      type: [String, Number]
    },
    disabledOption: {
      type: String,
      default: "Не указано"
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-select {
  color: $oc-gray-8;

  &:disabled {
    background-color: white;
    color: $oc-gray-8;
  }

  &:focus {
    box-shadow: none;
    border-color: $oc-blue-5;
  }
}
</style>
