<template>
  <div class="row">
    <div class="col-6">
      <div>Узел</div>
      <oy-search-select
        :options="nodes"
        :clearable="false"
        :value="card.nodeName || 'Не указано'"
        :disabled="
          !columnScopeHas(card.board_id, card.column_id, 'edit_card_node')
        "
        @input="onNodeSelected"
        :style="{
          backgroundColor: 'white',
          fontSize: '13px',
          minWidth: '13rem'
        }"
      />
    </div>
    <div class="col-6">
      <div>Тип включения</div>
      <oy-search-select
        :options="['СКС', 'GEPON', 'ВОК']"
        :value="card.connectionType || 'Не указано'"
        :clearable="false"
        :disabled="
          !columnScopeHas(card.board_id, card.column_id, 'edit_card_node')
        "
        @input="onConnectionTypeSelected"
        :style="{
          backgroundColor: 'white',
          fontSize: '13px',
          minWidth: '13rem'
        }"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: "node",
  computed: {
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    nodesBoard: function() {
      return this.$store.getters["kanban/boards/rawInstanceByName"]("Узлы");
    },
    nodesColumns: function() {
      return this.$store.getters["kanban/columns/findRawByBoardId"](
        this.nodesBoard._id
      );
    },
    nodes: function() {
      return this.nodesColumns.map(el => {
        // const regExp = /\(([^)]+)\)/;
        // const matches = regExp.exec(el.name);
        // if (matches) return matches[1];
        return el.name;
      });
    }
  },
  methods: {
    onNodeSelected(value) {
      this.$emit("nodeSelected", value);
    },
    onConnectionTypeSelected(value) {
      this.$emit("connectionTypeSelected", value);
    }
  }
};
</script>
