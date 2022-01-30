<template>
  <div class="checkbox">
    <label
      :class="[
        'checkbox__container',
        'mb-0',
        `checkbox__container--padding-${checkboxPosition}`
      ]"
      ><slot></slot>
      <input
        type="checkbox"
        :value="value"
        :checked="value"
        :disabled="disabled"
        @change="onChange"
      />
      <span
        :class="[
          'checkbox__checkmark',
          `checkbox__checkmark--${checkboxPosition}`
        ]"
      ></span>
    </label>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean,
      required: false,
      default: Boolean(0)
    },
    disabled: {
      type: Boolean,
      required: false,
      default: Boolean(0)
    },
    "checkbox-position": {
      type: String,
      required: false,
      default: "right"
    }
  },
  methods: {
    onChange(event) {
      let value = event.target.value !== "true";
      this.$emit("input", value);
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.checkbox {
  &__container {
    display: block;
    position: relative;
    margin-bottom: 12px;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    font-size: 13px;

    input {
      position: absolute;
      opacity: 0;
      cursor: pointer;
      height: 0;
      width: 0;
    }

    &--padding-left {
      padding-left: 35px;
    }

    &--padding-right {
      padding-right: 35px;
    }
  }

  &__checkmark {
    position: absolute;
    top: 0;
    height: 22px;
    width: 22px;
    background-color: white;
    border: 1px solid $oc-gray-3;
    border-radius: 3px;
    transition: 0.2s;

    &--right {
      right: 0;
    }

    &--left {
      left: 0;
    }

    &::after {
      content: "";
      position: absolute;
      display: none;
    }
  }

  &__container:hover input ~ &__checkmark {
    background-color: $oc-gray-0;
  }

  &__container input:checked ~ &__checkmark {
    &::after {
      display: block;
    }
  }
}

.checkbox__container .checkbox__checkmark:after {
  left: 8px;
  top: 3px;
  width: 6px;
  height: 12px;
  border: solid $oc-green-7;
  border-width: 0 2px 2px 0;
  -webkit-transform: rotate(45deg);
  -ms-transform: rotate(45deg);
  transform: rotate(45deg);
}
</style>
