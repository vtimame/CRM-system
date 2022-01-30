<template>
  <wrapper :options="options" :emitCLick="true" @click="close">
    <div class="board-permissions">
      <div class="board-permissions__header">
        <div>
          <span>Board permissions</span>
          <span v-if="current_role_id !== null">
            - {{ current_role_instance.name }}
          </span>
        </div>
        <!--        <div v-if="selected !== null">-->
        <!--          <button class="btn btn-sm btn-success">Выдать все права</button>-->
        <!--          <button class="btn btn-sm btn-danger ml-2">Забрать все права</button>-->
        <!--        </div>-->
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
          <permissions-list
            v-else
            :role_id="current_role_id"
          ></permissions-list>
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import rolesList from "../roles-list.vue";
import permissionsList from "../../board-page/board-actions/board-permissions-list.vue";

export default {
  mixins: [modal],
  data: () => ({
    selected: null
  }),
  computed: {
    current_role_id: function() {
      return this.$store.getters["settings/boardsPermissions/role_id"];
    },
    current_role_instance: function() {
      return this.$store.getters["roles/instance"](this.current_role_id);
    }
  },
  methods: {
    async onRoleSelected(role_id) {
      this.$store.commit("settings/boardsPermissions/setRoleId", role_id);
      await this.$store.dispatch("settings/boardsPermissions/loadPermissions");
    },
    close() {
      this.$store.commit("settings/boardsPermissions/setRoleId", null);
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
