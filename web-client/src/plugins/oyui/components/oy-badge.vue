<template>
  <div class="oy-badge">
    <div
      v-if="visible"
      class="oy-badge__indicator"
      :style="{ [indicator_position]: 0 }"
    >
      <oy-feather-icon
        type="circle"
        size="12"
        :stroke="open_color"
        :fill="open_color"
      />
    </div>
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: {
    color: {
      type: String,
      default: "green"
    },
    visible: {
      type: Boolean,
      default: true
    },
    level: {
      type: [String, Number],
      default: 7
    },
    position: {
      type: String,
      default: "bottom"
    }
  },
  computed: {
    default_color: function() {
      if (!this.$oc.green[this.level]) return this.$oc.green[7];
      return this.$oc.green[this.level];
    },
    open_color: function() {
      const color = this.$oc[this.color];
      if (!color) return this.default_color;
      if (!color[this.level]) return color[7];
      return color[this.level];
    },
    indicator_position: function() {
      if (this.position !== "top" || this.position !== "bottom") {
        return "bottom";
      }

      return this.position;
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-badge {
  position: relative;

  &__indicator {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 12px;
    height: 12px;
    position: absolute;
    right: -0.2rem;
    border-radius: 100%;
    border: 2px solid white;
  }
}
</style>
