<template>
  <a-layout-header class="default-layout__header">
    <div class="logotype">
      <logotype></logotype>
    </div>
    <div :style="{ display: 'flex', flex: 1 }">
      <div class="search-area"></div>
      <div class="user-menu">
        <a-dropdown :trigger="['hover']">
          <a-avatar
            :style="{
              cursor: 'pointer',
              backgroundColor: $oc.red[2],
              color: $oc.red[7],
              fontWeight: 600,
            }"
            >{{ user.surname[0] }}{{ user.name[0] }}</a-avatar
          >
          <a-menu slot="overlay">
            <a-menu-item @click="logout">
              Выйти
            </a-menu-item>
          </a-menu>
        </a-dropdown>
      </div>
    </div>
  </a-layout-header>
</template>

<script>
import { Layout, Dropdown, Menu, Icon, Avatar } from 'ant-design-vue';
import logotype from '../logotype.vue';
import userAvatar from '../default-layout/user-avatar.vue';

export default {
  computed: {
    user: function () {
      return this.$store.getters['auth/user'];
    },
  },
  components: {
    logotype,
    userAvatar,
    'a-layout-header': Layout.Header,
    'a-dropdown': Dropdown,
    'a-menu': Menu,
    'a-menu-item': Menu.Item,
    'a-icon': Icon,
    'a-avatar': Avatar,
  },
  methods: {
    async logout() {
      await this.$store.dispatch('auth/logout');
      this.$router.push({ name: 'login-page' });
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.default-layout {
  &__header {
    background-color: white;
    border-bottom: 1px solid $oc-gray-2;
    display: flex;
    flex-direction: row;
    align-items: center;
    padding: 0;

    .logotype {
      width: 270px;
      padding: 0 1.5rem;
      display: flex;
      justify-content: center;
      align-items: center;

      svg {
        fill: #cc0000;
        width: 115px;
      }
    }

    .search-area {
      width: 350px;
    }

    .user-menu {
      flex: 1;
      display: flex;
      justify-content: flex-end;
      padding: 0 1.5rem;
    }
  }
}
</style>
