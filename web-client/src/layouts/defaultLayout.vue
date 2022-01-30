<template>
  <div class="default-layout">
    <header class="default-layout__header">
      <mobile-aside
        :opened="mobile.aside_visible"
        @close="mobile.aside_visible = false"
      >
        <aside-nav @close="mobile.aside_visible = false"></aside-nav>
      </mobile-aside>
      <notifications
        :opened="notifications_opened"
        @close-notifications="notifications_opened = false"
      />
      <div class="d-block d-md-none pl-3">
        <oy-feather-icon
          type="menu"
          :style="{ cursor: 'pointer' }"
          @click="mobile.aside_visible = true"
        />
      </div>
      <div class="default-layout__header-logo d-none d-md-flex">
        <logotype></logotype>
      </div>
      <div class="default-layout__header-other">
        <div class="default-layout__header-searchbar">
          <!--          Search-->
        </div>
        <div class="default-layout__header-nav">
          <header-nav
            @open-notifications="notifications_opened = true"
          ></header-nav>
        </div>
      </div>
    </header>
    <main class="default-layout__main">
      <aside class="default-layout__aside d-none d-md-block">
        <aside-nav></aside-nav>
      </aside>
      <section class="default-layout__content">
        <transition name="fade" mode="out-in">
          <router-view></router-view>
        </transition>
      </section>
    </main>
    <modals />
  </div>
</template>

<script>
import Vue from "vue";
import store from "../store";
import logotype from "../components/common/logotype.vue";
import headerNav from "../components/default-layout/header-nav.vue";
import asideNav from "../components/default-layout/aside-nav.vue";
import modals from "../components/common/modals.vue";
import notifications from "../components/common/drawers/notifications.vue";
import mobileAside from "../components/common/drawers/mobile-aside.vue";
import Echo from "laravel-echo";
import MobileAside from "../components/common/drawers/mobile-aside";
window.io = require("socket.io-client");

export default {
  async beforeRouteEnter(to, from, next) {
    await store.dispatch("user/loadUser");
    await store.dispatch("kanban/columns/loadColumns");
    await store.dispatch("kanban/boards/loadBoards");
    await store.dispatch("kanban/cards/loadRawCards");
    await store.dispatch("kanban/columns/loadRawColumns");
    await store.dispatch("kanban/boards/loadRawBoards");
    await store.dispatch("users/loadUsers");
    await store.dispatch("divisions/loadDivisions");
    await store.dispatch("app/settings/loadSettingsInstance");

    if (typeof io !== "undefined" && !window.Echo) {
      const echo = new Echo({
        broadcaster: "socket.io",
        host: `${process.env.VUE_APP_API_URL}:6001`,
        transports: ["websocket", "polling", "flashsocket"],
        auth: {
          headers: {
            Authorization: `Bearer ${store.getters["user/token"]}`
          }
        }
      });

      window.Echo = echo;
      Vue.prototype.$echo = echo;
    }

    next();
  },
  data: () => ({
    notifications_opened: false,
    whats_new_opened: false,
    mobile: {
      aside_visible: false
    }
  }),
  mounted() {
    this.$axios.defaults.headers["X-Socket-ID"] = this.$echo.socketId();
    this.$store.dispatch("roles/loadRoles");
    this.$echo.join(`app`);
  },
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    token: function() {
      return this.$store.getters["user/token"];
    }
  },
  components: {
    MobileAside,
    logotype,
    headerNav,
    asideNav,
    modals,
    notifications
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

$border: 1px solid $oc-gray-3;
$aside-width: 300px;

.default-layout {
  display: flex;
  flex-direction: column;
  height: 100vh;

  &__header {
    display: flex;
    align-items: center;
    border-bottom: $border;
    background-color: white;

    &-logo {
      width: $aside-width;
      padding: 0.7rem 1.5rem;
      display: flex;
      justify-content: center;
    }

    &-other {
      flex: 1;
      display: flex;
      align-items: center;
      padding: 0.7rem 1.5rem 0.7rem 0;
    }

    &-serach {
      width: $aside-width;
    }

    &-nav {
      flex: 1;
      display: flex;
      justify-content: flex-end;
    }
  }

  &__main {
    flex: 1;
    display: flex;
    flex-direction: row;
  }

  &__aside {
    border-right: $border;
    padding: 0.5rem 0;
    background-color: white;
    display: flex;
    flex-direction: column;
  }

  &__content {
    flex: 1;
    position: relative;
  }
}
</style>
