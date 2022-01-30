<template>
  <div class="column-permissions-list">
    <div class="column-permissions-list__actions mb-2">
      <a href="#" @click.prevent="giveAllScope(permissions_types)"
        >Выдать все</a
      >
      /
      <a href="#" @click.prevent="removeAllScope(permissions_types)"
        >Забрать все</a
      >
    </div>
    <div v-for="(type, i) in permissions_types" :key="i">
      <div
        class="column-permissions-list__title d-flex justify-content-between align-items-center"
        @click="type.opened = !type.opened"
      >
        <span>{{ type.section_name }}</span>
        <oy-feather-icon
          :type="`chevron-${type.opened ? 'up' : 'down'}`"
          size="18"
        ></oy-feather-icon>
      </div>
      <div v-if="type.opened">
        <div v-for="(rule, i) in type.rules" :key="i">
          <view_cards
            v-if="rule.component && rule.name === 'view_cards'"
            :is="rule.name"
            @change="onComponentRuleChange(rule.name, $event)"
            :rule-value="view_cards_permission.value"
            :rule-selected-roles="view_cards_permission.roles"
          />
          <view_calls
            v-else-if="rule.component && rule.name === 'view_calls'"
            :is="rule.name"
            @change="onComponentRuleChange(rule.name, $event)"
            :rule-value="view_calls_permission.value"
            :rule-selected-roles="view_calls_permission.roles"
          />
          <view_meetings
            v-else-if="rule.component && rule.name === 'view_meetings'"
            :is="rule.name"
            @change="onComponentRuleChange(rule.name, $event)"
            :rule-value="view_meetings_permission.value"
            :rule-selected-roles="view_meetings_permission.roles"
          />
          <oy-checkbox
            v-else
            class="mb-2"
            @input="onScopeChange($event, rule.name)"
            :value="scopeHas(rule.name)"
            >{{ rule.title }}</oy-checkbox
          >
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { chain, map, flatten } from "lodash";
import permissionsListMixin from "./permissionsListMixin";
import view_cards from "./view_cards.vue";
import view_calls from "./view_calls";
import view_meetings from "./view_meetings";

export default {
  mixins: [permissionsListMixin],
  computed: {
    permissions: function() {
      return this.$store.getters["settings/columnsPermissions/instance"];
    },
    view_cards_permission: function() {
      return {
        value: this.permissions?.view_cards?.value,
        roles: this.permissions?.view_cards?.role_list
      };
    },
    view_calls_permission: function() {
      return {
        value: this.permissions?.view_calls?.value,
        roles: this.permissions?.view_calls?.role_list
      };
    },
    view_meetings_permission: function() {
      return {
        value: this.permissions?.view_meetings?.value,
        roles: this.permissions?.view_meetings?.role_list
      };
    },
    scope: function() {
      return this.permissions?.scope;
    }
  },
  components: {
    view_cards,
    view_calls,
    view_meetings
  },
  methods: {
    scopeHas(name) {
      return this.scope?.find(el => el === name) !== undefined;
    },
    onScopeChange(value, name) {
      this.$store.dispatch("settings/columnsPermissions/updateScope", {
        scope: [name],
        remove: value === false
      });
    },
    giveAllScope() {
      this.$store.dispatch("settings/columnsPermissions/updateScope", {
        scope: this.getRulesList(this.permissions_types),
        remove: false
      });
    },
    removeAllScope() {
      this.$store.dispatch("settings/columnsPermissions/updateScope", {
        scope: this.getRulesList(this.permissions_types),
        remove: true
      });
    },
    getRulesList(list) {
      console.log(list);
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
    },
    onComponentRuleChange(name, data) {
      this.$store.dispatch("settings/columnsPermissions/updatePermission", {
        name,
        data
      });
    }
  }
};
</script>

<style lang="scss" scoped>
.column-permissions-list {
  &__actions {
    font-size: 13px;
  }

  &__title {
    font-weight: 600;
    cursor: pointer;
  }
}
</style>
