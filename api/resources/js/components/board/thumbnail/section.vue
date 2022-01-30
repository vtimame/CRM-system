<template>
  <div class="thumbnail-section">
    <div v-if="title" class="thumbnail-section__title">
      <div class="thumbnail-section__title__left-border"></div>
      <div class="thumbnail-section__title__label">{{ title }}</div>
      <div class="thumbnail-section__title__right-border"></div>
    </div>
    <div class="thumbnail-section__content">
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
@import '~open-color/open-color';

.thumbnail-section {
  &__title {
    display: flex;
    align-items: center;

    &__left-border {
      width: 0.5rem;
      height: 1px;
      background-color: $oc-gray-2;
    }

    &__label {
      font-size: 11px;
      padding: 0.1rem 0.5rem;
      background-color: $oc-gray-2;
      border-radius: 3px;
    }

    &__right-border {
      flex: 1;
      height: 1px;
      background-color: $oc-gray-2;
    }
  }

  &__content {
    padding: 0.3rem 0.7rem;
  }
}
</style>
