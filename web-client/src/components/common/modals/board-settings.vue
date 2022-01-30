<template>
  <wrapper :options="options">
    <div class="board-settings">
      <div class="board-settings__header">Настройки доски</div>
      <div class="board-settings__content" ref="content">
        <oy-action-button
          v-if="boardScopeHas(board_id, 'edit_board_permissions')"
          @click="
            $modal.open({
              name: 'board-permissions',
              width: '650px',
              position: 'top'
            })
          "
          >Права на доску</oy-action-button
        >
        <div v-if="boardScopeHas(board_id, 'edit_column_permissions')">
          <div :style="{ fontWeight: 600 }">Колонки</div>
          <oy-action-button
            v-for="column in columns"
            :key="column._id"
            @click="
              $modal.open({
                name: 'column-settings',
                width: '350px',
                position: 'top',
                column
              })
            "
            >{{ column.name }}</oy-action-button
          >
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";

export default {
  mixins: [modal],

  computed: {
    board_id: function() {
      return this.$route.params.board_id;
    },
    columns: function() {
      return this.$store.getters["kanban/columns/findRawByBoardId"](
        this.board_id
      );
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.board-settings {
  &__header,
  &__content {
    padding: 0.5rem 1rem;
  }

  &__header {
    font-size: 1rem;
    font-weight: 600;
    border-bottom: 1px solid $oc-gray-3;
  }
}
</style>
