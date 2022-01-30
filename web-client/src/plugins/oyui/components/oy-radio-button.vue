<template>
  <div class="radio-buttons" :class="{ 'radio-buttons--disabled': disabled }">
    <label
      class="radio-button radio-button__true"
      :class="{ 'radio-button__true--checked': value === true }"
    >
      Да
      <input type="radio" :checked="value === true" @click="clicked(true)" />
    </label>
    <label
      class="radio-button radio-button__false"
      :class="{ 'radio-button__false--checked': value === false }"
    >
      Нет
      <input type="radio" :checked="value === false" @click="clicked(false)" />
    </label>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Boolean,
      required: false,
      default: undefined
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    clicked(state) {
      if (!this.disabled) {
        this.$emit("change", state);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.radio-buttons {
  display: flex;

  input {
    display: none;
  }

  .radio-button {
    font-size: 13px;
    padding: 0.28rem 0.8rem;
    cursor: pointer;
    transition: 0.2s;
    background-color: $oc-gray-2;
    margin-bottom: 0;

    &__true {
      padding: 0.28rem 1.01rem;
      border-top-left-radius: 3px;
      border-bottom-left-radius: 3px;

      &:hover {
        color: white;
        background-color: $oc-green-5;
      }

      &--checked {
        color: white;
        background-color: $oc-green-7;
      }
    }

    &__false {
      border-left: 1px solid $oc-gray-3;
      border-top-right-radius: 3px;
      border-bottom-right-radius: 3px;

      &:hover {
        color: white;
        background-color: $oc-red-5;
      }

      &--checked {
        color: white;
        background-color: $oc-red-7;
      }
    }
  }
}
</style>
