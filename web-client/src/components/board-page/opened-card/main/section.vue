<template>
  <div class="section">
    <div class="section__header">
      <div v-if="title" class="section__title">{{ title }}</div>
      <div v-if="$slots.title">
        <slot name="title"></slot>
      </div>
      <div v-if="$slots.extra">
        <slot name="extra"></slot>
      </div>
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
.section {
  padding: 0.5rem 1rem;

  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &__title {
    font-size: 1rem;
    font-weight: 600;
  }
}
</style>
