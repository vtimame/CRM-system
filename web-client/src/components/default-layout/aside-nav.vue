<template>
  <div
    class="aside-nav h-100 d-flex flex-column"
    :class="{ 'aside-nav--mini': mini }"
  >
    <div class="flex-grow-1">
      <aside-nav-item
        icon="grid"
        title="Рабочий стол"
        :mini="mini"
        @click="pushIn('dashboard-page')"
        :selected="$route.name === 'dashboard-page'"
      />
      <aside-nav-item
        v-if="systemScopeHas('view_boards_section')"
        :subnav="true"
        icon="columns"
        :mini="mini"
        title="Доски задач"
        :opened="$route.name === 'board-page'"
      >
        <div v-for="board in boards" :key="board._id">
          <aside-nav-item
            v-if="boardScopeHas(board._id, 'view_board')"
            :title="board.name"
            @click="pushIn('board-page', { board_id: board._id })"
            :selected="$route.params.board_id === board._id"
          />
        </div>
        <aside-nav-item
          v-if="systemScopeHas('add_boards')"
          @click="
            $modal.open({
              name: 'add-board',
              width: '350px',
              position: 'top'
            })
          "
          title="Добавить доску"
          :style="{ fontWeight: 600 }"
        />
      </aside-nav-item>
      <aside-nav-item
        icon="pie-chart"
        title="Статистика"
        v-if="systemScopeHas('view_stats_section')"
        :mini="mini"
        :subnav="true"
      >
        <aside-nav-item
          title="Воронка продаж"
          v-if="systemScopeHas('view_sales_funnel')"
          @click="pushIn('sales-funnel-page')"
          :selected="$route.name === 'sales-funnel-page'"
        />
        <aside-nav-item
          title="Услуги"
          v-if="systemScopeHas('view_services_stats')"
          @click="pushIn('services-stats-page')"
          :selected="$route.name === 'services-stats-page'"
        />
        <aside-nav-item
          title="Звонки и встречи"
          v-if="systemScopeHas('view_manager_events_stats')"
          @click="pushIn('manager-events-stats-page')"
          :selected="$route.name === 'manager-events-stats-page'"
        />
      </aside-nav-item>
      <aside-nav-item
        v-if="systemScopeHas('edit_system_permissions')"
        icon="settings"
        title="Управление"
        :mini="mini"
        :subnav="true"
      >
        <aside-nav-item
          title="Права ролей"
          @click="
            $modal.open({
              name: 'global-permissions',
              width: '650px',
              position: 'top'
            })
          "
        />
        <aside-nav-item
          v-if="systemScopeHas('edit_users')"
          title="Пользователи"
          @click="pushIn('users-page')"
          :selected="$route.name === 'users-page'"
        />
        <aside-nav-item
          v-if="systemScopeHas('edit_divisions')"
          title="Отделы"
          @click="pushIn('divisions-page')"
          :selected="$route.name === 'divisions-page'"
        />
        <aside-nav-item
          v-if="systemScopeHas('edit_pbx_settings')"
          title="Телефония"
          @click="pushIn('pbx-page')"
          :selected="$route.name === 'pbx-page'"
        />
        <aside-nav-item
          v-if="systemScopeHas('edit_site_integration_settings')"
          title="Интеграция с сайтом"
          @click="pushIn('site-integration-page')"
          :selected="$route.name === 'site-integration-page'"
        />
      </aside-nav-item>
    </div>
    <div>
      <aside-nav-item
        icon="bookmark"
        title="Телефонный справочник"
        :mini="mini"
        @click="pushIn('phonebook-page')"
        :selected="$route.name === 'phonebook-page'"
      />
      <aside-nav-item
        icon="info"
        title="Что нового?"
        :mini="mini"
        @click="pushIn('changelog-page')"
        :selected="$route.name === 'changelog-page'"
      />
    </div>
    <oy-circle-button
      @click="onMiniClick"
      class="collapse-button d-none d-md-flex"
      size="26"
      :custom-style="{
        backgroundColor: 'white',
        border: `1px solid ${$oc.gray[3]}`
      }"
    >
      <oy-feather-icon :type="`chevron-${mini ? 'right' : 'left'}`" size="14" />
    </oy-circle-button>
  </div>
</template>

<script>
import { isMobile } from "mobile-device-detect";
import asideNavItem from "./aside-nav/aside-nav-item.vue";

export default {
  data: () => ({
    mini: isMobile
      ? false
      : Number(window.localStorage.getItem("aside-mini")) === 1 || false
  }),
  computed: {
    boards: function() {
      return this.$store.getters["kanban/boards/list"];
    }
  },
  components: {
    asideNavItem
  },
  methods: {
    pushIn(name, params = null) {
      let options = { name };

      if (params !== null) {
        options = Object.assign({}, options, { params });
      }

      if (this.$route.name !== name) {
        this.$router.push(options);
      } else {
        if (params === null) return false;
        Object.keys(params).forEach(key => {
          if (this.$route.params[key] !== params[key]) {
            this.$router.push(options);
          }
        });
      }

      this.$emit("close");
    },
    onMiniClick() {
      window.localStorage.setItem("aside-mini", Number(!this.mini));
      this.mini = !this.mini;
    }
  }
};
</script>

<style lang="scss" scoped>
.aside-nav {
  position: relative;
  width: 300px;
  transition: width 0.25s ease-in-out;

  &--mini {
    width: 55px;
  }
}

.collapse-button {
  position: absolute;
  top: -20px;
  right: -13px;
  z-index: 1;
}
</style>
