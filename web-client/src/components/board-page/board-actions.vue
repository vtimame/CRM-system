<template>
  <div class="d-flex justify-content-end flex-column flex-lg-row">
    <div class="d-flex mb-2 mb-lg-0">
      <button
        class="btn btn-primary btn-sm d-flex align-items-center"
        @click="
          $modal.open({
            name: 'filter-cards',
            width: '350px',
            position: 'top'
          })
        "
      >
        <oy-feather-icon
          class="mr-0 mr-lg-2"
          type="filter"
          size="14"
        ></oy-feather-icon>
        <span class="d-none d-lg-block">Фильтр</span>
        <oy-feather-icon
          class="ml-2"
          type="circle"
          size="12"
          :stroke="selected_creator ? $oc.green[5] : 'white'"
          :fill="selected_creator ? $oc.green[5] : 'white'"
        ></oy-feather-icon>
      </button>
      <button
        v-if="boardScopeHas(board_id, 'add_columns')"
        class="btn btn-success btn-sm d-flex align-items-center ml-2"
        @click="
          $modal.open({
            name: 'add-column',
            width: '350px',
            position: 'top'
          })
        "
      >
        <oy-feather-icon
          class="mr-0 mr-lg-2"
          type="columns"
          size="14"
        ></oy-feather-icon>
        <span class="d-none d-lg-block">Добавить колонку</span>
      </button>
      <button
        v-if="
          boardScopeHas(board_id, 'edit_board_permissions') ||
            boardScopeHas(board_id, 'edit_column_permissions')
        "
        class="btn btn-danger btn-sm d-flex align-items-center ml-2"
        @click="
          $modal.open({
            name: 'board-settings',
            width: '350px',
            position: 'top'
          })
        "
      >
        <oy-feather-icon
          class="mr-0 mr-md-2"
          type="sliders"
          size="14"
        ></oy-feather-icon>
        <span class="d-none d-md-block">Настройки</span>
      </button>
    </div>
    <search-bar class="ml-0 ml-lg-2" />
  </div>
</template>

<script>
import searchBar from "./board-actions/search-bar.vue";

export default {
  data: () => ({
    settings_visible: false
  }),
  computed: {
    board_id: function() {
      return this.$route.params.board_id;
    },
    selected_creator: function() {
      return this.$store.getters["kanban/cards/selected_creator"];
    }
  },
  components: {
    searchBar
  }
};
</script>
