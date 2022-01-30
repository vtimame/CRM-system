<template>
  <div
    class="oy-label"
    :style="{ backgroundColor: color, fontWeight: small ? 500 : 600 }"
  >
    <div
      class="d-flex justify-content-between align-items-center"
      :class="{ 'oy-label--hover': hover }"
    >
      <div
        :style="{ padding: labelPadding }"
        @click="$emit('click')"
        class="flex-grow-1"
      >
        {{ name }}
      </div>
      <div
        v-if="closable"
        :style="{ cursor: 'pointer' }"
        @click="$emit('close')"
        class="pr-2"
      >
        <oy-feather-icon
          type="x"
          :size="iconSize"
          :style="{ marginTop: large ? 0 : '-2px' }"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    name: {
      type: String
    },
    color: {
      type: String
    },
    large: {
      type: Boolean,
      default: false
    },
    small: {
      type: Boolean,
      default: false
    },
    closable: {
      type: Boolean,
      default: false
    },
    hover: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    labelPadding: function() {
      if (this.large) return "0.3rem 1rem";
      if (this.small) return "0.06rem 0.4rem";
      return "0.15rem 0.7rem";
    },
    iconSize: function() {
      if (this.large) return "18";
      return "14";
    }
  }
};
</script>

<style lang="scss" scoped>
.oy-label {
  color: white;

  border-radius: 3px;

  &--hover {
    cursor: pointer;
    background-color: transparent;
    transition: 0.25s ease-in-out;
    border-radius: 3px;

    &:hover {
      background-color: rgba(0, 0, 0, 0.1);
    }
  }
}
</style>
