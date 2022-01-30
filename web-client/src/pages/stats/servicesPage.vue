<template>
  <div class="services d-flex flex-column">
    <div
      class="services__header d-flex justify-content-between align-items-center"
    >
      <div class="services__title">Услуги</div>
      <div class="services__actions d-flex align-items-center">
        <!--        <div class="mr-2 d-flex">-->
        <!--          <div v-for="id in creators" :key="id">-->
        <!--            <div class="ml-2">-->
        <!--              <oy-badge-->
        <!--                :visible="filterCreators.find(el => el === id) !== undefined"-->
        <!--              >-->
        <!--                <oy-avatar-->
        <!--                  :data="$store.getters['users/instance'](id)"-->
        <!--                  @click="onCreatorClick(id)"-->
        <!--                />-->
        <!--              </oy-badge>-->
        <!--            </div>-->
        <!--          </div>-->
        <!--        </div>-->
        <div class="mr-2">
          <oy-dates-range
            :range="datesRange"
            @change="onRangeChange"
            class="mr-2"
          />
        </div>
        <div class="mr-2">
          <oy-search-select
            :options="boards"
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
        <div>
          <oy-search-select
            :options="columns"
            label="name"
            :value="filterColumn ? filterColumn : columns[0]"
            :clearable="false"
            @input="onFilterColumnSelected"
            :style="{
              backgroundColor: 'white',
              fontSize: '13px',
              minWidth: '13rem'
            }"
          />
        </div>
      </div>
    </div>
    <div class="services__content flex-grow-1 pb-3">
      <table
        class="table table-sm table-hover table-bordered my-3"
        :style="{ backgroundColor: 'white' }"
      >
        <tbody v-for="(item, i) in statsData" :key="i">
          <tr>
            <td colspan="3" :style="{ fontWeight: 600, fontSize: '16px' }">
              {{ item.user.surname }} {{ item.user.name }} -
              {{ getTotalPrice(item.cards) }}
            </td>
          </tr>
          <tr v-for="(card, o) in item.cards" :key="o">
            <td class="w-50">{{ card.title }}</td>
            <td class="p-0">
              <!--              <div v-for="(service, p) in card.services" :key="p">-->
              <!--                {{ service.title }} - {{ service.price }}-->
              <!--              </div>-->
              <div>
                <table
                  class="table table-sm table-bordered m-0"
                  :style="{ border: 'none' }"
                >
                  <tbody>
                    <tr v-for="(service, p) in card.services" :key="p">
                      <td class="w-50">{{ service.title }}</td>
                      <td>{{ service.price }}</td>
                    </tr>
                    <tr :style="{ fontWeight: 600 }">
                      <td>Итого</td>
                      <td>{{ getCardPrice(card.services) }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
      <div>
        Общая сумма: <span :style="{ fontWeight: 600 }">{{ fullPrice }}</span>
      </div>
    </div>
  </div>
</template>

<script>
import uniq from "lodash/uniq";
import flatten from "lodash/flatten";

export default {
  name: "services-page",
  async mounted() {
    if (!this.systemScopeHas("view_services_stats")) {
      await this.$router.push({ name: "not-found-page" });
    }

    await this.$store.dispatch("kanban/columns/loadRawColumns");
    this.filterBoard = this.boards[0];
    this.filterColumn = this.columns[0];
    const date = new Date(),
      y = date.getFullYear(),
      m = date.getMonth();
    const start = new Date(y, m, 1);
    const end = new Date(y, m + 1, 0);

    this.datesRange = { start, end };
    setTimeout(() => {
      this.loadStats();
    }, 1000);
  },
  data: () => ({
    datesRange: null,
    filterBoard: null,
    filterColumn: null,
    filterCreators: [],
    statsData: []
  }),
  computed: {
    fullPrice: function() {
      let price = 0;

      this.statsData.map(el =>
        el.cards.map(card =>
          card.services.map(sr => (price += Number(sr.price)))
        )
      );

      return price;
    },
    cards: function() {
      return this.$store.getters["app/stats/services/cards"];
    },
    boards: function() {
      return this.$store.getters["kanban/boards/list"];
    },
    columns: function() {
      return this.$store.getters["kanban/columns/rawList"].filter(
        el => el.board_id === this.filterBoard._id
      );
    },
    creators: function() {
      return uniq(this.cards.map(el => el.creator_id));
    }
  },
  methods: {
    getCardPrice(services) {
      let price = 0;
      services.map(el => (price += Number(el.price)));
      return price;
    },
    getTotalPrice(cards) {
      let price = 0;
      cards.map(card => card.services.map(el => (price += Number(el.price))));
      return price;
    },
    async loadStats() {
      this.statsData = [];
      await this.$store.dispatch(
        "app/stats/services/loadCards",
        Object.assign({}, this.datesRange, {
          board_id: this.filterBoard._id,
          column_id: this.filterColumn._id
        })
      );
      this.setData();
    },
    setData() {
      this.cards.forEach(card => {
        if (!card.services) return;
        const index = this.statsData.findIndex(
          el => el.creator_id === card.creator_id
        );
        if (index !== -1) {
          // card.services.map(el => {
          //   el.client = card.title;
          // });
          // this.statsData[index].services.push(card.services);
          this.statsData[index].cards.push(card);
        } else {
          this.statsData.push({
            creator_id: card.creator_id,
            cards: [card]
          });
          // card.services.map(el => {
          //   el.client = card.title;
          // });
          // this.statsData.push({
          //   creator_id: card.creator_id,
          //   services: card.services
          // });
        }
      });
      this.statsData.map(el => {
        el.user = this.$store.getters["users/instance"](el.creator_id);
        // el.services = flatten(el.services);
        return el;
      });
    },
    async onRangeChange(range) {
      this.datesRange = range;
      await this.loadStats();
    },
    async onFilterBoardSelected(board) {
      this.filterBoard = board;
      this.filterColumn = this.columns[0];
      await this.loadStats();
    },
    async onFilterColumnSelected(column) {
      this.filterColumn = column;
      await this.loadStats();
    },
    onCreatorClick(id) {
      if (this.filterCreators.find(el => el === id)) {
        this.filterCreators = this.filterCreators.filter(el => el !== id);
      } else {
        this.filterCreators.push(id);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.services {
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
}
</style>
