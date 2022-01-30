<template>
  <settings :is-opened="isOpened" @close="$emit('close')" title="Настройки">
    <div class="mb-2">
      <oy-search-select
        :options="potencial_boards"
        label="name"
        value="Выберите доску"
        :clearable="false"
        @input="onBoardSelected"
      />
    </div>
    <div>
      <div
        v-for="item in funnelColumns"
        :key="item.board_id"
        class="sales-funnel-settings__board mb-2"
      >
        <div
          class="sales-funnel-settings__board__header d-flex justify-content-between align-items-center px-1 px-2 py-1"
        >
          <div :style="{ fontWeight: 600 }">
            {{ getBoard(item.board_id).name }}
          </div>
          <oy-feather-icon
            type="x"
            size="16"
            :style="{ cursor: 'pointer' }"
            @click="onBoardDelete(item.board_id)"
          />
        </div>
        <div class="px-1 px-2 py-2">
          <div class="mb-2">
            <oy-search-select
              :options="getPotencialColumns(item.board_id)"
              label="name"
              value="Выберите колонку"
              :style="{ fontSize: '13px' }"
              :clearable="false"
              @input="onColumnSelected"
            />
          </div>
          <oy-action-button v-for="column_id in item.columns" :key="column_id"
            >{{ getColumn(column_id).name }}
            <oy-feather-icon
              type="x"
              slot="postfix"
              size="16"
              :style="{ cursor: 'pointer' }"
              @click="onColumnDelete(item.board_id, column_id)"
          /></oy-action-button>
        </div>
      </div>
    </div>
  </settings>
</template>

<script>
import settings from "./settings";

export default {
  name: "sales-funnel-settings",
  props: {
    isOpened: {
      type: Boolean,
      default: false
    }
  },
  components: {
    settings
  },
  computed: {
    settings: function() {
      const settings = this.$store.getters["app/settings/instance"];
      return settings
        ? settings
        : {
            salesFunnel: []
          };
    },
    funnelColumns: function() {
      return this.settings.salesFunnel ? this.settings.salesFunnel : [];
    },
    potencial_boards: function() {
      return this.boards.filter(board => {
        return !this.funnelColumns.find(el => el.board_id === board._id);
      });
    },
    boards: function() {
      return this.$store.getters["kanban/boards/list"];
    },
    columns: function() {
      return this.$store.getters["kanban/columns/rawList"];
    }
  },
  methods: {
    getBoard(id) {
      return this.boards.find(el => el._id === id);
    },
    getColumn(id) {
      return this.columns.find(el => el._id === id);
    },
    getPotencialColumns(board_id) {
      const columns = this.columns.filter(el => el.board_id === board_id);
      const index = this.settings.salesFunnel.findIndex(
        el => el.board_id === board_id
      );
      if (index !== -1) {
        return columns.filter(
          col =>
            !this.settings.salesFunnel[index].columns.find(el => el === col._id)
        );
      }

      return columns;
    },
    async onBoardSelected(board) {
      this.settings.salesFunnel.push({ board_id: board._id, columns: [] });
      await this.$store.dispatch(
        "app/settings/updateSettingsInstance",
        this.settings
      );
    },
    async onColumnSelected(column) {
      const index = this.settings.salesFunnel.findIndex(
        el => el.board_id === column.board_id
      );
      if (index !== -1) {
        this.settings.salesFunnel[index].columns.push(column._id);
      }
      await this.$store.dispatch(
        "app/settings/updateSettingsInstance",
        this.settings
      );
    },
    async onBoardDelete(id) {
      const settings = this.settings;
      settings.salesFunnel = this.settings.salesFunnel.filter(
        el => el.board_id !== id
      );

      await this.$store.dispatch(
        "app/settings/updateSettingsInstance",
        settings
      );
    },
    async onColumnDelete(board_id, column_id) {
      const index = this.settings.salesFunnel.findIndex(
        el => el.board_id === board_id
      );
      if (index !== -1) {
        const settings = this.settings;
        settings.salesFunnel[index].columns = settings.salesFunnel[
          index
        ].columns.filter(el => el !== column_id);

        await this.$store.dispatch(
          "app/settings/updateSettingsInstance",
          settings
        );
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.sales-funnel-settings {
  &__board {
    border: 1px solid $oc-gray-2;
    border-radius: 3px;
    font-size: 13px;

    &__header {
      border-bottom: 1px solid $oc-gray-2;
    }
  }
}
</style>
