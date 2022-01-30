<template>
  <div class="board-permissions-list">
    <div class="board-permissions-list__actions mb-2">
      <a href="#" @click.prevent="giveAllScope">Выдать все</a> /
      <a href="#" @click.prevent="removeAllScope">Забрать все</a>
    </div>
    <div v-for="(type, i) in permissions_types" :key="i">
      <div
        class="board-permissions-list__title d-flex justify-content-between align-items-center"
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
        section_name: "Доска",
        opened: false,
        rules: [
          { title: "Просмотр", name: "view_board" },
          { title: "Редактирование названия", name: "rename_board" },
          { title: "Редактирование прав", name: "edit_board_permissions" },
          { title: "Редактирование меток", name: "edit_board_labels" }
        ]
      },
      {
        section_name: "Колонки",
        opened: false,
        rules: [
          { title: "Добавление", name: "add_columns" },
          { title: "Редактирование названия", name: "rename_columns" },
          { title: "Перемещение", name: "move_columns" },
          { title: "Редактирование прав", name: "edit_column_permissions" }
        ]
      }
    ]
  }),
  computed: {
    board_id: function() {
      return this.$route.params.board_id;
    },
    permissions: function() {
      return this.$store.getters["settings/boardsPermissions/instance"];
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
      this.$store.dispatch("settings/boardsPermissions/updateScope", {
        scope: [name],
        remove: value === false
      });
    },
    giveAllScope() {
      this.$store.dispatch("settings/boardsPermissions/updateScope", {
        scope: this.getRulesList(this.permissions_types),
        remove: false
      });
    },
    removeAllScope() {
      this.$store.dispatch("settings/boardsPermissions/updateScope", {
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
.board-permissions-list {
  &__actions {
    font-size: 13px;
  }

  &__title {
    font-weight: 600;
    cursor: pointer;
  }
}
</style>
