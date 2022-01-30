<template>
  <div class="board-view">
    <div class="board-view__header">
      <a-page-header :ghost="true" :title="board.name">
        <template slot="extra">
          <a-button icon="filter" :disabled="true">
            Фильтр по создателям
          </a-button>
        </template>
      </a-page-header>
    </div>
    <div class="board-view__content" ref="columns">
      <div
        class="column-wrapper"
        v-for="column in board.columns"
        :key="column.id"
      >
        <column :column="column" />
        <div :style="{ width: '1rem' }"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { PageHeader, Button, Modal } from 'ant-design-vue';
import column from '../components/board/column.vue';
import { store } from '../vuex';

export default {
  async beforeRouteEnter(to, from, next) {
    store.dispatch('kanban/thumbnails/loadColumns', to.params.board_id);
    next();
  },
  beforeRouteUpdate(to, from, next) {
    if (Number(this.board.id) !== Number(to.params.board_id)) {
      this.$store.commit('kanban/thumbnails/set_loaded_state', false);
      this.$store.dispatch('kanban/thumbnails/loadColumns', to.params.board_id);
    }
    next();
  },
  async mounted() {
    if (this.$route.query.card_id) {
      await this.$store.dispatch(
        'kanban/card/loadCard',
        this.$route.query.card_id
      );
      this.$modal.open({
        name: 'opened-card',
        width: '850px',
        position: 'top',
      });
    }
  },
  beforeDestroy() {
    window.removeEventListener('wheel', this.wheelController, true);
  },
  computed: {
    board: function () {
      return this.$store.getters['kanban/boards/instance'](
        this.$route.params.board_id
      );
    },
  },
  methods: {
    wheelController(event) {
      if (event.target.closest('.column__body') !== null) return false;
      const columns = this.$refs.columns;
      if (columns) {
        if (event.deltaY > 0) columns.scrollLeft += 60;
        else columns.scrollLeft -= 60;
      }
    },
  },
  components: {
    column,
    'a-page-header': PageHeader,
    'a-button': Button,
    'a-modal': Modal,
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';
@import 'resources/js/assets/mixins';

.board-view {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  flex-direction: column;

  &__content {
    flex: 1;
    display: flex;
    overflow-y: hidden;
    overflow-x: auto;
    padding: 0 24px 24px 24px;
    @include scrollbars(10px, $oc-gray-5, $oc-gray-2);

    .column-wrapper {
      display: flex;
    }
  }
}
</style>
