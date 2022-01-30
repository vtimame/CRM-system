<template>
  <div class="oy-input">
    <div v-if="label" class="oy-input__label">{{ label }}</div>
    <div class="input-group input-group-sm">
      <div v-if="prefix" class="input-group-prepend">
        <span class="input-group-text">{{ prefix }}</span>
      </div>
      <input
        ref="input"
        :type="type"
        :value="value"
        :style="inputStyle"
        :disabled="disabled"
        @input="emitValue"
        @change="emitValue"
        @focus="$emit('focus')"
        @blur="$emit('blur')"
        @keyup="$emit('keyup', $event)"
        @keydown="$emit('keydown', $event)"
        @keypress="$emit('keypress', $event)"
        class="form-control"
        :class="{ 'has-error': error }"
        aria-label="Sizing example input"
        aria-describedby="inputGroup-sizing-sm"
        v-focus="autofocus"
        :placeholder="placeholder"
      />
      <div v-if="postfix" class="input-group-append">
        <span class="input-group-text">{{ postfix }}</span>
      </div>
      <div v-if="$slots.postfix" class="input-group-append">
        <slot name="postfix"></slot>
      </div>
      <transition name="input-error">
        <div
          v-if="error"
          class="error-mesage"
          :class="{ 'text-center': errorCenter }"
        >
          {{ error }}
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import Inputmask from "inputmask";

export default {
  props: {
    value: {
      type: [String, Number],
      default: ""
    },
    mask: {
      type: String
    },
    placeholder: {
      type: String,
      default: ""
    },
    label: {
      type: String
    },
    inputStyle: {
      type: Object,
      default: null
    },
    prefix: {
      type: String
    },
    postfix: {
      type: String
    },
    type: {
      type: String,
      default: "text"
    },
    error: {
      type: String
    },
    errorCenter: {
      type: Boolean,
      default: false
    },
    autofocus: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  mounted() {
    if (this.mask) {
      const im = new Inputmask(this.mask);
      im.mask(this.$refs.input);
    }
  },
  methods: {
    emitValue(event) {
      if (event.target.inputmask) {
        this.$emit(event.type, event.target.inputmask.unmaskedvalue());
      } else {
        this.$emit(event.type, event.target.value);
      }
    },
    focus() {
      this.$refs.input.focus();
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-input {
  position: relative;

  .form-control {
    color: $oc-gray-8;

    &:disabled {
      cursor: not-allowed;
      background-color: $oc-gray-0;
      color: $oc-gray-8;
    }

    &:focus {
      box-shadow: none;
      border-color: $oc-blue-5;
    }
  }

  .has-error {
    border-radius: 3px;
    border-color: $oc-red-7;

    &:focus {
      border-color: $oc-red-7;
    }
  }

  .error-mesage {
    position: absolute;
    bottom: -20px;
    font-size: 13px;
    color: $oc-red-7;
    width: 100%;
  }
}
</style>
