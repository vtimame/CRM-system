<template>
  <div class="profile-section">
    <slot></slot>
  </div>
</template>

<style lang="scss" scoped>
@import "~open-color/open-color";

.profile-section {
  border-bottom: 1px solid $oc-gray-2;
  padding: 0.5rem 1rem;

  &:last-child {
    border-bottom: none;
  }
}
</style>
