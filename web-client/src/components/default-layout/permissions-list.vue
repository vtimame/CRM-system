<template>
  <div class="system-permissions-list">
    <div class="system-permissions-list__actions mb-2">
      <a href="#" @click.prevent="giveAllScope">Выдать все</a> /
      <a href="#" @click.prevent="removeAllScope">Забрать все</a>
    </div>
    <div v-for="(type, i) in permissions_types" :key="i">
      <div
        class="system-permissions-list__title d-flex justify-content-between align-items-center"
        @click="type.opened = !type.opened"
      >
        <span>{{ type.section_name }}</span>
        <oy-feather-icon
          :type="`chevron-${type.opened ? 'up' : 'down'}`"
          size="18"
        ></oy-feather-icon>
      </div>
      <div v-if="type.opened">
        <oy-checkbox
          v-for="(rule, i) in type.rules"
          :key="i"
          class="mb-2"
          :value="scopeHas(rule.name)"
          @input="onScopeChange($event, rule.name)"
          >{{ rule.title }}</oy-checkbox
        >
      </div>
    </div>
  </div>
</template>

<script>
import { chain } from "lodash";

export default {
  data: () => ({
    permissions_types: [
      {
        section_name: "Доски задач",
        opened: false,
        rules: [
          { title: "Просмотр раздела", name: "view_boards_section" },
          { title: "Создание досок", name: "add_boards" },
          { title: "Удаление карточек", name: "delete_cards" }
        ]
      },
      {
        section_name: "Управление",
        opened: false,
        rules: [
          {
            title: "Редактирование системных прав",
            name: "edit_system_permissions"
          },
          {
            title: "Редактирование пользователей",
            name: "edit_users"
          },
          {
            title: "Редактирование отделов",
            name: "edit_divisions"
          },
          {
            title: "Настройка телефонии",
            name: "edit_pbx_settings"
          },
          {
            title: "Интеграция с сайтом",
            name: "edit_site_integration_settings"
          }
        ]
      },
      {
        section_name: "Статистика",
        opened: false,
        rules: [
          { title: "Просмотр раздела", name: "view_stats_section" },
          { title: "Воронка продаж", name: "view_sales_funnel" },
          { title: "Услуги", name: "view_services_stats" },
          { title: "Звонки и встречи", name: "view_manager_events_stats" }
        ]
      }
    ]
  }),
  computed: {
    permissions: function() {
      return this.$store.getters["settings/systemPermissions/instance"];
    },
    scope: function() {
      return this.permissions?.scope;
    }
  },
  methods: {
    scopeHas(name) {
      return this.scope?.find(el => el === name) !== undefined;
    },
    onScopeChange(value, name) {
      this.$store.dispatch("settings/systemPermissions/updateScope", {
        scope: [name],
        remove: value === false
      });
    },
    giveAllScope() {
      this.$store.dispatch("settings/systemPermissions/updateScope", {
        scope: this.getRulesList(this.permissions_types),
        remove: false
      });
    },
    removeAllScope() {
      this.$store.dispatch("settings/systemPermissions/updateScope", {
        scope: this.getRulesList(this.permissions_types),
        remove: true
      });
    },
    getRulesList(list) {
      let rules;
      if (list[0].rules) {
        rules = chain(list)
          .map("rules")
          .flatten()
          .value();
      } else {
        rules = list;
      }

      return chain(rules)
        .map("name")
        .flatten()
        .value();
    }
  }
};
</script>

<style lang="scss" scoped>
.system-permissions-list {
  &__actions {
    font-size: 13px;
  }

  &__title {
    font-weight: 600;
    cursor: pointer;
  }
}
</style>
