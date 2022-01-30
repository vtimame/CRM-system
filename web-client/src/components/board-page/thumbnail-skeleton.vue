<template>
  <div class="thumb-loading">
    <div class="thumb-loading__skeleton" :style="{ width: '80%' }"></div>
    <div class="thumb-loading__skeleton" :style="{ width: '18%' }"></div>
    <div class="thumb-loading__skeleton" :style="{ width: '100%' }"></div>
    <div class="thumb-loading__skeleton" :style="{ width: '18%' }"></div>
    <div class="thumb-loading__skeleton" :style="{ width: '100%' }"></div>
    <div class="thumb-loading__skeleton" :style="{ width: '100%' }"></div>
    <div class="thumb-loading__skeleton" :style="{ width: '100%' }"></div>
    <div class="thumb-loading__skeleton" :style="{ width: '18%' }"></div>
    <div class="thumb-loading__skeleton-avatars">
      <div class="thumb-loading__skeleton-avatar"></div>
      <div class="thumb-loading__skeleton-avatar"></div>
      <div class="thumb-loading__skeleton-avatar"></div>
      <div class="thumb-loading__skeleton-avatar"></div>
      <div class="thumb-loading__skeleton-avatar"></div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
@import "~open-color/open-color";

.thumb-loading {
  margin-bottom: 0.5rem;
  background-color: white;
  padding: 0.5rem 1rem 0.1rem 1rem;

  &__skeleton {
    height: 8px;
    margin-bottom: 8px;
    background-color: $oc-gray-3;

    &-avatars {
      display: flex;
      flex-wrap: wrap;
    }

    &-avatar {
      flex: 0 0 auto;
      width: 32px;
      height: 32px;
      border-radius: 100%;
      background-color: $oc-gray-3;
      margin-right: 0.5rem;
      margin-bottom: 0.5rem;
    }
  }
}
</style>
