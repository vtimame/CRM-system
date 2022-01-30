<template>
  <a-layout-sider
    v-model="collapsed"
    collapsible
    theme="light"
    class="default-layout__sider"
    width="270"
  >
    <a-menu
      theme="light"
      :default-selected-keys="defaultSelectedKeys"
      :default-open-keys="defaultOpenKeys"
      mode="inline"
      class="default-layout__sider-menu"
      @click="onMenuClick"
    >
      <a-menu-item
        key="dashboard-page"
        :style="{ display: 'flex', alignItems: 'center' }"
      >
        <a-icon :component="homeIcon" :style="{ fontSize: '18px' }" />
        <span>Рабочий стол</span>
      </a-menu-item>
      <a-sub-menu key="board-page">
        <span slot="title" :style="{ display: 'flex', alignItems: 'center' }"
          ><a-icon :component="columnIcon" :style="{ fontSize: '18px' }" /><span
            >Доски задач</span
          ></span
        >
        <a-menu-item v-for="board in boards" :key="`board-${board.id}`">
          {{ board.name }}
        </a-menu-item>
      </a-sub-menu>
      <a-sub-menu key="control">
        <span slot="title" :style="{ display: 'flex', alignItems: 'center' }"
          ><a-icon type="setting" :style="{ fontSize: '18px' }" /><span
            >Управление</span
          ></span
        >
        <a-menu-item key="control-employees-page">
          Сотрудники
        </a-menu-item>
        <a-menu-item key="control-boards-page">
          Доски задач
        </a-menu-item>
      </a-sub-menu>
    </a-menu>
  </a-layout-sider>
</template>

<script>
import { Icon, Layout, Menu } from 'ant-design-vue';
import homeIcon from '../icons/home.vue';
import columnIcon from '../icons/column.vue';
import cog from '../icons/cog.vue';

export default {
  data: () => ({
    collapsed: false,
    homeIcon: homeIcon,
    columnIcon: columnIcon,
    cog: cog,
  }),
  computed: {
    boards: function () {
      return this.$store.getters['kanban/boards/list'];
    },
    defaultSelectedKeys: function () {
      switch (this.$route.name) {
        case 'board-page':
          return [`board-${this.$route.params.board_id}`];
        default:
          return [this.$route.name];
      }
    },
    defaultOpenKeys: function () {
      if (this.$route.name.startsWith('control')) return ['control'];
      return [this.$route.name];
    },
  },
  components: {
    'a-layout-sider': Layout.Sider,
    'a-menu': Menu,
    'a-sub-menu': Menu.SubMenu,
    'a-menu-item': Menu.Item,
    'a-icon': Icon,
  },
  methods: {
    onMenuClick(event) {
      if (event.keyPath.find((el) => el === 'board-page')) {
        const board_id = Number(event.key.split('-')[1]);
        if (!isNaN(board_id))
          if (Number(this.$route.params.board_id) !== board_id) {
            this.$router.push({
              name: 'board-page',
              params: { board_id: board_id },
            });
          }
      } else {
        if (this.$route.name !== event.key)
          this.$router.push({ name: event.key });
      }
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.default-layout {
  &__sider {
    border-right: 1px solid $oc-gray-2;

    &-menu {
      border-right: none;
    }
  }
}
</style>
