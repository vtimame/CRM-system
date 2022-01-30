<template>
  <a-layout class="default-layout">
    <layout-header />
    <a-layout>
      <layout-sider />
      <a-layout :style="{ display: 'flex' }">
        <a-layout-content :style="{ flex: 1, position: 'relative' }">
          <router-view></router-view>
        </a-layout-content>
      </a-layout>
    </a-layout>
    <modals />
  </a-layout>
</template>

<script>
import layoutHeader from '../components/default-layout/layout-header.vue';
import layoutSider from '../components/default-layout/layout-sider.vue';
import modals from '../components/common/modals.vue';
import { Layout } from 'ant-design-vue';
import { store } from '../vuex';

export default {
  async beforeRouteEnter(to, from, next) {
    await store.dispatch('auth/loadUser');
    await store.dispatch('kanban/boards/loadBoards');
    next();
  },
  components: {
    'a-layout': Layout,
    'a-layout-content': Layout.Content,
    layoutHeader,
    layoutSider,
    modals,
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.default-layout {
  height: 100vh;
}
</style>
