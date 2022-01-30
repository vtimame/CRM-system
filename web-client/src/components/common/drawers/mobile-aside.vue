<template>
  <div class="mobile-aside">
    <transition name="fade">
      <div
        @click="$emit('close')"
        v-if="opened"
        class="mobile-aside__wrapper"
      ></div>
    </transition>
    <div
      class="mobile-aside__drawer"
      :class="{ 'mobile-aside__drawer--opened': opened }"
    >
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    opened: {
      type: Boolean,
      default: false
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.mobile-aside {
  &__wrapper {
    position: fixed;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
    background-color: rgba(0, 0, 0, 0.3);
    z-index: 2;
    cursor: pointer;
  }

  &__drawer {
    position: fixed;
    width: 100%;
    max-width: 301px;
    top: 0;
    left: 0;
    margin-left: -100%;
    background-color: white;
    height: 100%;
    z-index: 3;
    border-left: 1px solid $oc-gray-3;
    display: flex;
    flex-direction: column;
    transition: 0.25s cubic-bezier(0.82, 0.085, 0.395, 0.895);

    &--opened {
      margin-left: 0 !important;
    }
  }

  &__header {
    padding: 0.5rem 1rem;
    color: $oc-gray-8;
    border-bottom: 1px solid $oc-gray-3;
    display: flex;
    align-items: center;
    justify-content: space-between;

    &-title {
      font-weight: 600;
    }

    .read-icon {
      color: $oc-gray-6;
      transition: 0.2s ease-in-out;
      cursor: pointer;

      &:hover {
        color: $oc-gray-8;
      }
    }
  }

  &__body {
    flex: 1;
    overflow-y: auto;
    @include scrollbars(5px, $oc-gray-5, $oc-gray-3);
    padding: 0.3rem 1rem;
  }
}
</style>
