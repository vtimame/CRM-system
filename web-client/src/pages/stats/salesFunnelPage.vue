<template>
  <div class="sales-funnel d-flex flex-column">
    <div
      class="sales-funnel__header d-flex justify-content-between align-items-center"
    >
      <div class="sales-funnel__title">Воронка продаж</div>
      <div class="sales-funnel__actions d-flex align-items-center">
        <div class="mr-2 d-flex">
          <div v-for="id in creators" :key="id">
            <div class="ml-2">
              <oy-badge
                :visible="filterCreators.find(el => el === id) !== undefined"
              >
                <oy-avatar
                  :data="$store.getters['users/instance'](id)"
                  @click="onCreatorClick(id)"
                />
              </oy-badge>
            </div>
          </div>
        </div>
        <div class="mr-2">
          <oy-search-select
            :options="select_boards"
            label="name"
            :value="filterBoard ? filterBoard : boards[0]"
            :clearable="false"
            @input="onFilterBoardSelected"
            :style="{
              backgroundColor: 'white',
              fontSize: '13px',
              minWidth: '13rem'
            }"
          />
        </div>
        <oy-dates-range
          :range="datesRange"
          @change="onRangeChange"
          class="mr-2"
        />
        <oy-button type="danger" @click="drawers.settingsIsOpened = true"
          >Настройки</oy-button
        >
      </div>
    </div>
    <div class="sales-funnel__content flex-grow-1 d-flex pb-3">
      <div>
        <div class="mb-2">
          <span>Статистика по </span>
          <span v-if="filterCreators.length === 0" :style="{ fontWeight: 600 }"
            >всем</span
          >
          <span v-else>
            <span
              v-for="id in filterCreators"
              :key="id"
              :style="{ fontWeight: 600 }"
            >
              {{ $store.getters["users/instance"](id).surname }}
              {{ $store.getters["users/instance"](id).name }}
              <span v-if="filterCreators.length > 1">,</span>
            </span>
          </span>
        </div>
        <div class="mt-2">
          <vue-funnel-graph
            :width="width"
            :height="height"
            :labels="graphData.labels"
            :values="graphData.values"
            :colors="colors"
            :direction="direction"
            :gradient-direction="gradientDirection"
            :animated="false"
            :display-percentage="true"
          ></vue-funnel-graph>
        </div>
      </div>
    </div>
    <sales-funnel-settings
      :is-opened="drawers.settingsIsOpened"
      @close="drawers.settingsIsOpened = false"
    />
  </div>
</template>

<script>
import { VueFunnelGraph } from "vue-funnel-graph-js";
import uniq from "lodash/uniq";
import SalesFunnelSettings from "@/components/common/drawers/stats/salesFunnelSettings";

export default {
  name: "sales-funnel-page",
  async mounted() {
    if (!this.systemScopeHas("view_sales_funnel")) {
      this.$router.push({ name: "not-found-page" });
    }

    this.filterBoard = this.boards[0];
    const date = new Date(),
      y = date.getFullYear(),
      m = date.getMonth();
    const start = new Date(y, m, 1);
    const end = new Date(y, m + 1, 0);

    this.datesRange = { start, end };
    await this.$store.dispatch("kanban/columns/loadRawColumns");
    await this.$store.dispatch("kanban/cards/loadRawCards");
    await this.$store.dispatch(
      "app/stats/salesFunnel/loadCards",
      this.datesRange
    );
  },
  data: () => ({
    datesRange: null,
    filterBoard: null,
    filterCreators: [],
    colors: [["#FF3C8E", "#FFB178", "#7795FF"]],
    direction: "vertical",
    gradientDirection: "vertical",
    height: 700,
    width: 300,
    drawers: {
      settingsIsOpened: false
    }
  }),
  computed: {
    cards: function() {
      return this.$store.getters["app/stats/salesFunnel/cards"];
    },
    creatorsCards: function() {
      if (this.filterCreators.length > 0) {
        return this.cards.filter(card =>
          this.filterCreators.find(el => el === card.creator_id)
        );
      }

      return this.cards;
    },
    settings: function() {
      const settings = this.$store.getters["app/settings/instance"];
      return settings
        ? settings
        : {
            salesFunnelColumns: []
          };
    },
    funnelColumns: function() {
      return this.settings.salesFunnel ? this.settings.salesFunnel : [];
    },
    boards: function() {
      return this.$store.getters["kanban/boards/list"];
    },
    select_boards: function() {
      const boards = this.funnelColumns.map(el => el.board_id);
      return this.boards.filter(el => boards.find(id => id === el._id));
    },
    creators: function() {
      const cards = this.filterBoard
        ? this.cards.filter(el => el.board_id === this.filterBoard._id)
        : this.cards;
      return uniq(cards.map(el => el.creator_id));
    },
    graphData: function() {
      const data = {
        labels: [],
        values: []
      };

      const board_id = this.filterBoard
        ? this.filterBoard._id
        : this.boards[0]._id;
      const boardIndex = this.funnelColumns.findIndex(
        el => el.board_id === board_id
      );
      if (boardIndex !== -1) {
        const cards = this.creatorsCards.filter(
          el =>
            el.board_id === board_id &&
            this.funnelColumns[boardIndex].columns.find(
              id => id === el.column_id
            )
        );

        const filteredCardsByCreator =
          this.filterCreators.length > 0
            ? cards.filter(el =>
                this.filterCreators.find(id => el.creator_id === id)
              )
            : cards;
        const cardsWithEvents = filteredCardsByCreator.filter(
          el => el.move_events.length > 0
        );

        const invoiceCardsLength =
          this.filterCreators.length > 0
            ? this.cards.filter(el =>
                this.filterCreators.find(id => id === el.creator_id)
              ).length
            : this.cards.length;

        const index = this.funnelColumns.findIndex(
          el => el.board_id === board_id
        );

        if (index !== -1) {
          this.funnelColumns[index].columns.forEach(id => {
            const column = this.$store.getters["kanban/columns/instance"](id);
            if (column.name === "Входящие") {
              data.labels.push(column.name);
              data.values.push([invoiceCardsLength]);
            } else {
              const columnCards = cardsWithEvents.filter(el =>
                el.move_events.find(e => e.new_column_id === column._id)
              );
              data.labels.push(column.name);
              data.values.push([columnCards.length]);
            }
          });
        }
      }

      return data;
    }
  },
  methods: {
    onFilterBoardSelected(board) {
      this.filterCreators = [];
      this.filterBoard = board;
    },
    onRangeChange(event) {
      this.datesRange = event;
    },
    onCreatorClick(id) {
      if (this.filterCreators.find(el => el === id)) {
        this.filterCreators = this.filterCreators.filter(el => el !== id);
      } else {
        this.filterCreators.push(id);
      }
    }
  },
  components: {
    SalesFunnelSettings,
    VueFunnelGraph
  },
  watch: {
    datesRange: {
      handler(range) {
        this.$store.dispatch("app/stats/salesFunnel/loadCards", range);
      }
    }
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.sales-funnel {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 12px;
  overflow-y: auto;
  @include scrollbars(4px, $oc-gray-5, $oc-gray-3);

  &__title {
    font-weight: 600;
    font-size: 1.2rem;
  }

  .label__value,
  .label__title,
  .label__percentage,
  .label__segment-percentages,
  .svg-funnel-js__subLabel--title {
    color: #324148 !important;
  }
}
</style>
