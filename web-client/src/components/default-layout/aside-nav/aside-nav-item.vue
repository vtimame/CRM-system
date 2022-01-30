<template>
  <div>
    <div class="aside-nav-item" :class="{ selected }" @click="clicked">
      <oy-feather-icon
        v-if="icon"
        :type="icon"
        size="20"
        :stroke="nav_opened ? $oc.red[9] : 'currentColor'"
      ></oy-feather-icon>
      <span v-if="!mini" class="ml-3">{{ title }}</span>
      <div v-if="subnav && !mini" class="aside-nav-item__chevron">
        <oy-feather-icon
          :key="nav_opened"
          :type="`chevron-${nav_opened ? 'up' : 'down'}`"
          size="15"
        ></oy-feather-icon>
      </div>
    </div>
    <div v-if="nav_opened" class="aside-nav-item__subnav">
      <div :class="{ 'aside-nav-item__subnav--mini': mini }">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    subnav: {
      type: Boolean,
      default: false
    },
    mini: {
      type: Boolean,
      default: false
    },
    selected: {
      type: Boolean,
      default: false
    },
    icon: {
      type: String
    },
    title: {
      type: String
    },
    opened: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    nav_opened: false
  }),
  mounted() {
    if (!this.mini) {
      this.nav_opened = this.opened;
    }
  },
  methods: {
    clicked() {
      if (!this.subnav) {
        if (this.mini) {
          this.closeSubNav();
        }
        this.$emit("click");
      } else {
        if (!this.mini) this.nav_opened = !this.nav_opened;
        else {
          this.nav_opened = true;
          window.addEventListener("click", this.clickController, true);
        }
      }
    },
    clickController(event) {
      if (event.target.closest(".aside-nav-item__subnav") === null) {
        this.closeSubNav();
      }
    },
    closeSubNav() {
      window.removeEventListener("click", this.clickController, true);
      this.nav_opened = false;
    }
  },
  watch: {
    mini: {
      handler(value, oldValue) {
        if (value === true && this.nav_opened) {
          this.closeSubNav();
        }
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.aside-nav-item {
  padding: 0.5rem 1rem;
  cursor: pointer;
  transition: 0.2s;
  display: flex;
  align-items: center;
  user-select: none;
  border-left: 3px solid transparent;
  position: relative;

  &:hover {
    background-color: $oc-gray-2;
  }

  &__chevron {
    flex: 1;
    display: flex;
    justify-content: flex-end;
  }

  &__subnav {
    background-color: $oc-gray-1;

    &--mini {
      position: absolute;
      left: 60px;
      margin-top: -37px;
      z-index: 100;
      background-color: white;
      border: 1px solid $oc-gray-3;

      .aside-nav-item {
        padding-left: 0 !important;
        font-size: 13px;
      }
    }

    .aside-nav-item {
      padding-left: 2.3rem;
      font-size: 13px;
    }
  }
}

.selected {
  border-left-color: $oc-red-9;
}
</style>
