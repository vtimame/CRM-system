<template>
  <wrapper :options="options" :emitCLick="true" @click="close">
    <div class="board-permissions">
      <div class="board-permissions__header">
        <div>
          <span>Column permissions</span>
          <span v-if="current_role_id !== null">
            - {{ current_role_instance.name }}
          </span>
        </div>
      </div>
      <div class="board-permissions__content d-flex">
        <div class="board-permissions__roles-list">
          <roles-list
            :selected="current_role_id"
            @selected="onRoleSelected"
          ></roles-list>
        </div>
        <div class="board-permissions__permissions-list">
          <div
            v-if="current_role_id === null"
            class="board-permissions__permissions-list-empty"
          >
            Сначала выберите роль
          </div>
          <permissions-list v-else />
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import rolesList from "../roles-list.vue";
import permissionsList from "../../board-page/column/column-permissions-list.vue";

export default {
  mixins: [modal],
  computed: {
    current_role_id: function() {
      return this.$store.getters["settings/columnsPermissions/role_id"];
    },
    current_role_instance: function() {
      return this.$store.getters["roles/instance"](this.current_role_id);
    }
  },
  methods: {
    async onRoleSelected(role_id) {
      await this.$store.commit(
        "settings/columnsPermissions/setRoleId",
        role_id
      );
      await this.$store.dispatch("settings/columnsPermissions/loadPermissions");
    },
    close() {
      this.$store.commit("settings/columnsPermissions/setRoleId", null);
      this.$store.commit("settings/columnsPermissions/setColumnId", null);
      this.$modal.close(this.options.name);
    }
  },
  components: {
    rolesList,
    permissionsList
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.board-permissions {
  &__header {
    /*font-size: 1rem;*/
    font-weight: 600;
    padding: 0.5rem 1rem;
    border-bottom: 1px solid $oc-gray-3;
    display: flex;
    justify-content: space-between;
  }

  &__roles-list {
    width: 300px;
    border-right: 1px solid $oc-gray-3;
    padding: 0.5rem 1rem;
  }

  &__permissions-list {
    flex: 1;
    padding: 0.5rem 1rem;

    &-empty {
      display: flex;
      justify-content: center;
      font-weight: 600;
    }
  }
}
</style>
