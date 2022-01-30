<template>
  <div class="card-section">
    <div v-if="title" class="card-section__title">{{ title }}</div>
    <div class="card-section__content">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    title: {
      type: String,
    },
  },
};
</script>

<style lang="scss" scoped>
.card-section {
  padding: 0.5rem 1rem;

  &__title {
    font-weight: 600;
    font-size: 1rem;
  }
}
</style>
