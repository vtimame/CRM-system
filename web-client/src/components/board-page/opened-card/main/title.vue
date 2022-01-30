<template>
  <div class="card-title mb-0">
    <oy-input
      v-model="$v.title.$model"
      :disabled="disabled"
      @focus="focused = true"
      @blur="focused = false"
      @change="onChange"
      placeholder="Введите название карточки"
      :input-style="{
        fontSize: '1rem',
        fontWeight: 600,
        border: 'none',
        padding: '0 1rem'
      }"
    />
    <div
      class="card-title__divider"
      :class="{
        'card-title__divider--focused': focused,
        'card-title__divider--has-error': !$v.title.required
      }"
    ></div>
  </div>
</template>

<script>
import { required } from "vuelidate/lib/validators";

export default {
  props: {
    value: {
      type: String
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    focused: false,
    title: ""
  }),
  mounted() {
    this.title = this.value;
  },
  validations: {
    title: {
      required
    }
  },
  methods: {
    onChange() {
      this.$emit("onErrorChange", !this.$v.title.$error);
      if (this.$v.title.required) {
        this.$emit("change", this.title);
      }
    }
  },
  watch: {
    value: function(newVal, oldVal) {
      this.title = newVal;
    }
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-title {
  position: relative;

  .close-icon {
    position: absolute;
    z-index: 3;
    right: 10px;
    top: 7px;
  }

  &__divider {
    transition: 0.2s;
    border-bottom: 1px solid transparent;

    &--focused {
      border-color: $oc-blue-5;
    }

    &--has-error {
      border-color: $oc-red-5;
    }
  }
}
</style>
