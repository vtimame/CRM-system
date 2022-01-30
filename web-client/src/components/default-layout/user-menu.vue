<template>
  <div class="user-menu">
    <oy-avatar @click="onClick" :data="user"></oy-avatar>
    <transition name="user-menu">
      <div v-if="visible" class="user-menu__overlay">
        <div class="user-menu__user-data">
          <oy-avatar :style="{ flex: '0 0 auto' }" :data="user"></oy-avatar>
          <div class="ml-2 user-menu__user-name">
            <div :style="{ fontWeight: 600 }">
              {{ user.surname }} {{ user.name }}
            </div>
            <div :style="{ fontSize: '11px' }">{{ userPosition }}</div>
          </div>
        </div>
        <div class="user-menu__actions">
          <div class="user-menu__action" @click="openDevicesModal">
            <span>Устройства</span>
          </div>
          <div class="user-menu__action" @click="logout">
            Выйти
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  props: {
    user: {
      type: Object,
      required: true
    }
  },
  data: () => ({
    visible: false
  }),
  computed: {
    userPosition: function() {
      const position = this.user.role_display;
      if (position && position.length > 0) return position;
      return this.user.role.name;
    }
  },
  methods: {
    onClick() {
      if (!this.visible) {
        this.addClickListener();
        this.visible = true;
      } else {
        this.removeClickListener();
        this.visible = false;
      }
    },
    clickController(event) {
      if (event.target.closest(".user-menu") === null) {
        this.removeClickListener();
        this.visible = false;
      }
    },
    addClickListener() {
      window.addEventListener("click", this.clickController, true);
    },
    removeClickListener() {
      window.removeEventListener("click", this.clickController, true);
    },
    openDevicesModal() {
      this.$modal.open({
        name: "manage-tokens",
        width: "550px",
        position: "top"
      });
      this.visible = false;
    },
    async logout() {
      await this.$store.dispatch("user/logout");
      //
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.user-menu {
  position: relative;

  &__overlay {
    position: absolute;
    right: 0;
    margin-top: 5px;
    user-select: none;
    background-color: white;
    border: 1px solid $oc-gray-3;
    width: 15rem;
    z-index: 2;
  }

  &__user-data {
    display: flex;
    align-items: center;
    padding: 0.5rem;
    border-bottom: 1px solid $oc-gray-3;
  }

  &__user-name {
    flex: 1;
    font-size: 13px;
    line-height: 13px;
  }

  &__actions {
    padding: 0.2rem 0;
  }

  &__action {
    padding: 0.4rem 0.7rem;
    cursor: pointer;
    transition: 0.2s;
    font-size: 13px;

    &:hover {
      background-color: $oc-gray-1;
    }
  }
}
</style>
