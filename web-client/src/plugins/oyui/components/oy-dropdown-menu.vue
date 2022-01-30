<template>
  <div class="oy-dropdown">
    <div @click="onTriggerClick" class="oy-dropdown__trigger">
      <slot name="trigger"></slot>
    </div>
    <transition name="fade">
      <div v-if="opened" class="oy-dropdown__menu">
        <slot name="item"></slot>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  data: () => ({
    opened: false
  }),
  methods: {
    onTriggerClick() {
      this.opened = true;
      window.addEventListener("click", this.clickController, true);
    },
    clickController(event) {
      if (event.target.closest(".oy-dropdown__menu") === null) {
        this.opened = false;
        window.removeEventListener("click", this.clickController, true);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-dropdown {
  position: relative;

  &__trigger {
  }

  &__menu {
    position: absolute;
    border: 1px solid $oc-gray-3;
    background-color: white;
    right: 0;
    padding: 0.2rem 0;
    z-index: 2;
  }
}
</style>
