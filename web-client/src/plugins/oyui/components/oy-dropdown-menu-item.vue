<template>
  <div class="oy-dropdown-item" @click="$emit('click')">
    <slot></slot>
  </div>
</template>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-dropdown-item {
  padding: 0.2rem 1rem;
  font-size: 13px;
  color: $oc-gray-8;
  cursor: pointer;
  transition: 0.2s;
  min-width: 12rem;

  &:hover {
    background-color: $oc-gray-1;
  }
}
</style>
