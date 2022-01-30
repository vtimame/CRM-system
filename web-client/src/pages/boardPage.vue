<template>
  <div class="board-page py-0 py-lg-2" :key="$route.params.board_id">
    <div
      class="board-page__header d-flex justify-content-between flex-column flex-lg-row"
    >
      <div class="board-page__header-title">
        <span v-if="!boardScopeHas(board._id, 'rename_board')">{{
          board.name
        }}</span>
        <oy-input
          v-else
          :value="board.name"
          :input-style="boardTitleInputStyle"
          @change="onRenameBoard"
        />
      </div>
      <div class="board-page__header-actions flex-grow-1">
        <board-actions></board-actions>
      </div>
    </div>
    <div class="board-page__content" ref="columns">
      <div
        v-for="column in columns"
        :key="column._id"
        :style="{ maxHeight: '100%', flex: '0 0 auto' }"
      >
        <column :column="column" :drag="drag" @drag="drag = $event"></column>
      </div>
    </div>
  </div>
</template>

<script>
import horseIcon from "../assets/images/horse.svg";
import column from "../components/board-page/column.vue";
import boardActions from "../components/board-page/board-actions.vue";
import store from "../store";

export default {
  data: () => ({
    horseIcon: horseIcon,
    drag: false
  }),
  mounted() {
    const board_id = this.$route.params.board_id;
    if (
      !this.systemScopeHas("view_boards_section") ||
      !this.boardScopeHas(board_id, "view_board")
    ) {
      this.$router.push({ name: "not-found-page" });
    } else {
      this.loadCards().then(() => {
        this.loadOpenedCard();
      });
      this.$store.commit(
        "settings/boardsPermissions/setBoardId",
        this.$route.params.board_id
      );
      this.$store.commit(
        "settings/columnsPermissions/setBoardId",
        this.$route.params.board_id
      );
      this.listenBoardChannel();
      window.addEventListener("wheel", this.wheelController, true);

      this.$echo
        .private(`board.${this.board._id}`)
        .listenForWhisper("cardWasAdded", event => {
          this.$store.commit(
            "kanban/columns/addThumbnailInColumnByIndex",
            event
          );
        })
        .listenForWhisper("cardWasRemoved", event => {
          this.$store.commit(
            "kanban/columns/removeThumbnailFromColumnByIndex",
            event
          );
        })
        .listenForWhisper("setCardData", event => {
          this.$store.commit("kanban/cards/setCardData", event);
        })
        .listenForWhisper("pushContact", event => {
          this.$store.commit("kanban/cards/pushContact", event);
        })
        .listenForWhisper("updateContact", event => {
          this.$store.commit("kanban/cards/updateContact", event);
        })
        .listenForWhisper("deleteContact", event => {
          this.$store.commit("kanban/cards/deleteContact", event);
        })
        .listenForWhisper("addMember", ({ card_id, member_id }) => {
          this.$store.commit("kanban/cards/pushMember", { card_id, member_id });
        })
        .listenForWhisper("deleteMember", ({ card_id, member_id }) => {
          this.$store.commit("kanban/cards/deleteMember", {
            card_id,
            member_id
          });
        });
    }
  },
  beforeDestroy() {
    window.removeEventListener("wheel", this.wheelController, true);
    this.$echo.leave(`presence-board.${this.$route.params.board_id}`);
  },
  beforeUpdate() {
    this.$echo.leave(`presence-board.${this.$route.params.board_id}`);
  },
  computed: {
    board: function() {
      return this.$store.getters["kanban/boards/instance"](
        this.$route.params.board_id
      );
    },
    columns: function() {
      return this.$store.getters["kanban/columns/findByBoardId"](
        this.board._id
      );
    },
    boardTitleInputStyle: function() {
      return {
        border: "none",
        backgroundColor: "transparent",
        fontSize: "1.2rem",
        height: "auto",
        fontWeight: 600,
        padding: 0
      };
    }
  },
  components: {
    column,
    boardActions
  },
  methods: {
    listenBoardChannel() {
      this.$echo
        .join(`board.${this.board._id}`)
        .listen("BoardWasUpdated", e => {
          this.$store.commit("kanban/boards/updateBoardData", e.data);
        })
        .listen("ColumnWasUpdated", e => {
          this.$store.commit("kanban/boards/updateColumnData", e.data);
        })
        .listen("CardWasAdded", e => {
          this.$store.commit("kanban/cards/pushCard", e.data);
        });
    },
    async loadOpenedCard() {
      const card_id = this.$route.query.card_id;
      if (card_id !== undefined) {
        // await this.$store.dispatch("kanban/card/loadCard", card_id);
        this.$modal.open({
          name: "opened-card",
          width: "850px",
          position: "top"
        });
      }
    },
    wheelController(event) {
      const columns = this.$refs.columns;
      const y = event.deltaY > 0;
      const x = event.deltaX;

      if (
        event.target.closest(".column__body") !== null ||
        event.target.closest(".board-page") === null
      ) {
        return false;
      }

      if (columns) {
        if (x !== 0) {
          return;
          // if (x > 0) columns.scrollLeft += 60;
          // if (x < 0) columns.scrollLeft -= 60;
        } else {
          if (y) columns.scrollLeft += 60;
          if (!y) columns.scrollLeft -= 60;
        }
      }
    },
    onRenameBoard(value) {
      this.$store.dispatch("kanban/boards/updateBoard", {
        name: value,
        board_id: this.board._id
      });
    },
    async loadCards() {
      await this.$store.dispatch(
        "kanban/cards/loadCards",
        this.$route.params.board_id
      );
    }
  },
  watch: {
    $route(to, from) {
      if (!to.params.board_id) return false;
      if (to.params.board_id !== from.params.board_id) {
        this.loadCards();
        this.listenBoardChannel();
        this.$store.commit(
          "settings/boardsPermissions/setBoardId",
          this.$route.params.board_id
        );
        this.$store.commit(
          "settings/columnsPermissions/setBoardId",
          this.$route.params.board_id
        );
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.board-page {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  flex-direction: column;
  background-color: #f8f9f9;

  &__header {
    padding: 0 1rem;

    &-title {
      font-size: 1.2rem;
      font-weight: 600;
    }
  }

  &__content {
    flex: 1;
    display: flex;
    padding: 0.5rem 1rem;
    overflow: auto hidden;
    @include scrollbars(10px, $oc-gray-5, $oc-gray-3);
  }

  &__dnd-container {
    display: flex;
  }

  &__empty {
    .title {
      font-weight: 600;
      font-size: 1.2rem;
      line-height: 1.2rem;
    }
  }
}
</style>
