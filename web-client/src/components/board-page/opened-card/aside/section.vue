<template>
  <div class="aside-section">
    <div
      v-if="title"
      class="aside-section__title d-flex align-items-center justify-content-between"
    >
      <div>{{ title }}</div>
      <div v-if="$slots.extra">
        <slot name="extra"></slot>
      </div>
    </div>
    <div v-if="$slots.title">
      <slot name="title"></slot>
    </div>
    <slot></slot>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String
    }
  }
};
</script>

<style lang="scss" scoped>
.aside-section {
  &__title {
    font-size: 13px;
    font-weight: 600;
    text-transform: uppercase;
    margin-bottom: 0.3rem;
  }
}
</style>
