<template>
  <svg
    @click="$emit('click')"
    :width="size"
    :height="size"
    :fill="fill"
    :stroke="stroke"
    :stroke-width="strokeWidth"
    :stroke-linecap="strokeLinecap"
    :stroke-linejoin="strokeLinejoin"
  >
    <use :xlink:href="`${sprite}#${type}`" />
  </svg>
</template>

<script>
import sprite from "feather-icons/dist/feather-sprite.svg";
export default {
  props: {
    type: {
      type: String,
      default: "activity"
    },
    fill: {
      type: String,
      default: "none"
    },
    stroke: {
      type: String,
      default: "currentColor"
    },
    strokeWidth: {
      type: String,
      default: "2"
    },
    strokeLinecap: {
      type: String,
      default: "round"
    },
    strokeLinejoin: {
      type: String,
      default: "round"
    },
    size: {
      type: String,
      default: "24"
    }
  },
  data: () => ({
    sprite: sprite
  })
};
</script>
