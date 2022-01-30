<template>
  <div class="column__wrapper h-100">
    <div class="column" :class="{ 'h-100': drag }">
      <div
        v-if="inputbar_visible"
        class="column__inputbar"
        :class="{ 'column__inputbar--focused': inputbar_is_focused }"
      >
        <oy-input
          ref="header-input"
          :value="inputmode === 'search' ? search_value : column.name"
          @input="onInputKeydown"
          @change="onInputChange"
          @focus="inputbar_is_focused = true"
          @blur="inputbar_is_focused = false"
          :input-style="{
            borderRadius: 0,
            border: 'none',
            padding: '1.22rem 1rem',
            fontWeight: 600
          }"
        />
      </div>
      <div v-else class="column__header d-flex justify-content-between">
        <div class="column__header-title" :style="{ flex: 1 }">
          {{ column.name }}
        </div>
        <div>
          <oy-feather-icon
            v-if="boardScopeHas(board._id, 'rename_columns')"
            type="edit-3"
            size="14"
            @click="openRename"
            :style="{ cursor: 'pointer' }"
          />
          <oy-feather-icon
            :style="{ cursor: 'pointer' }"
            type="search"
            size="14"
            class="ml-2"
            @click="openSearch"
          ></oy-feather-icon>
        </div>
      </div>
      <div
        class="column__body"
        v-infinite-scroll="loadMore"
        :infinite-scroll-disabled="busy"
      >
        <component
          :is="isMobile ? 'div' : 'draggable'"
          :class="{ 'h-100': drag }"
          :list="cards"
          group="column"
          @change="onDropCard"
          @start="$emit('drag', true)"
          @end="$emit('drag', false)"
          ghost-class="column__ghost"
        >
          <thumbnail
            v-for="card in cards"
            :key="card._id"
            :card="card"
          ></thumbnail>
        </component>
      </div>
      <div class="column__footer">
        <button
          v-if="columnScopeHas(board._id, column._id, 'add_cards')"
          class="column__add-card-btn d-flex align-items-center justify-content-center"
          @click="
            $modal.open({
              name: 'add-card',
              width: '850px',
              position: 'top',
              column
            })
          "
        >
          <oy-feather-icon type="plus" size="13"></oy-feather-icon>
          <span class="ml-2">Добавить карточку</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { isMobile } from "mobile-device-detect";
import draggable from "vuedraggable";
import thumbnail from "./thumbnail.vue";
import cardService from "../../services/cardService";
import _orderBy from "lodash/orderBy";
import moment from "moment";
import Fuse from "fuse.js";
import Toast, { POSITION } from "vue-toastification";

export default {
  props: {
    column: {
      type: Object
    },
    drag: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    inputbar_visible: false,
    inputmode: "search",
    inputbar_is_focused: false,
    search_value: "",
    all_cards_loaded: false,
    card_limit: 6
  }),
  computed: {
    isMobile: function() {
      return isMobile;
    },
    board: function() {
      return this.$store.getters["kanban/boards/instance"](
        this.$route.params.board_id
      );
    },
    busy: function() {
      return this.cards.length >= this.all_cards.length;
    },
    all_cards: {
      get: function() {
        const cards = this.$store.getters["kanban/cards/columnCards"]({
          column_id: this.column._id,
          board_id: this.column.board_id
        });

        if (!this.selected_creator) return cards;
        else return cards.filter(el => el.creator_id === this.selected_creator);
      },
      set: function(list) {}
    },
    selected_creator: function() {
      return this.$store.getters["kanban/cards/selected_creator"];
    },
    cards: function() {
      const board_search = this.$store.getters["kanban/cards/search_value"];
      const all_cards = _orderBy(this.all_cards, ["updated_at"], ["desc"]);

      if (this.search_value === "" && board_search === "") {
        return _orderBy(
          this.all_cards.slice(0, this.card_limit),
          ["updated_at"],
          ["desc"]
        );
      }

      const fuse = new Fuse(all_cards, {
        minMatchCharLength: 3,
        keys: [
          "title",
          "address.street",
          "address.street_num",
          "contacts.name",
          "contacts.surname"
        ]
      });

      return fuse.search(this.search_value || board_search).map(el => el.item);
    },
    permissions: function() {
      return this.$store.getters["user/permissions/columnPermissions"]({
        board_id: this.column.board_id,
        column_id: this.column._id
      });
    },
    user: function() {
      return this.$store.getters["user/instance"];
    }
  },
  methods: {
    loadMore() {
      this.card_limit += 6;
    },
    loadCards() {
      const loaded_cards = this.cards.map(el => el._id);
      this.$store.dispatch("kanban/cards/loadCards", {
        columns: [this.column._id],
        loaded_cards,
        board_id: this.column.board_id,
        offset: this.cards.length,
        limit: this.column.cards_count
      });
      this.all_cards_loaded = true;
    },
    onInputKeydown(value) {
      if (this.inputmode === "search") {
        this.search_value = value;
      }
    },
    onInputChange(value) {
      if (this.inputmode === "rename") {
        this.$store.dispatch("kanban/boards/updateColumn", {
          board_id: this.column.board_id,
          column_id: this.column._id,
          name: value
        });
      }
    },
    openSearch() {
      this.inputmode = "search";
      this.showInputBar();
    },
    openRename() {
      this.inputmode = "rename";
      this.showInputBar();
    },
    showInputBar() {
      this.inputbar_visible = true;
      window.addEventListener("click", this.clickController, true);
      setTimeout(() => {
        this.$refs["header-input"].focus();
      }, 10);
    },
    hideSearchBar() {
      this.inputbar_visible = false;
      this.search_value = "";
      window.removeEventListener("click", this.clickController, true);
    },
    clickController(event) {
      if (event.target.closest(".column__inputbar") === null) {
        this.hideSearchBar();
      }
    },
    async onDropCard(event) {
      if (event.added) {
        const old_column_id = event.added.element.column_id;
        const new_column_id = this.column._id;

        await cardService.updateCard(event.added.element._id, {
          column_id: this.column._id
        });
        this.$store.commit("kanban/cards/setCardData", {
          card_id: event.added.element._id,
          payload: { column_id: this.column._id }
        });
        this.$store.commit("kanban/cards/setCardData", {
          card_id: event.added.element._id,
          payload: { updated_at: moment().format("YYYY-MM-DD HH:mm:ss") }
        });
        const members = await this.$store.dispatch(
          "kanban/cards/autoAddMembers",
          event.added.element._id
        );

        await this.$store.dispatch("kanban/cards/createMoveEvent", {
          card_id: event.added.element._id,
          old_column_id,
          new_column_id
        });

        this.$echo
          .private(`board.${this.$route.params.board_id}`)
          .whisper("setCardData", {
            card_id: event.added.element._id,
            payload: { column_id: this.column._id }
          });

        this.$echo
          .private(`board.${this.$route.params.board_id}`)
          .whisper("setCardData", {
            card_id: event.added.element._id,
            payload: { members }
          });

        if (
          this.columnScopeHas(
            this.board._id,
            this.column._id,
            "notify_services_actualization"
          )
        ) {
          this.$toast.error("В этой колонке требуется актуализация услуг!", {
            timeout: 0,
            position: POSITION.BOTTOM_RIGHT
          });
        }
      }
    }
  },
  components: {
    thumbnail,
    draggable
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.column {
  background-color: #ebecf0;
  max-height: 100%;
  display: flex;
  flex-direction: column;
  border-radius: 7px;

  &__ghost {
    border: 1px dashed $oc-blue-3;
  }

  &__draggable {
    cursor: move;
  }

  &__searchbar {
    border-bottom: 1px solid $oc-gray-3;
  }

  &__inputbar {
    border-bottom: 1px solid transparent;
    &--focused {
      border-color: $oc-blue-3;
    }
  }

  &__wrapper {
    width: 300px;
    overflow-y: hidden;
    margin-right: 1rem;
  }

  &__header {
    user-select: none;
    padding: 0.5rem;
    border-bottom: 1px solid $oc-gray-3;
    position: relative;

    &-title {
      font-weight: 600;
      color: $oc-gray-9;
    }
  }

  &__body {
    flex: 1;
    padding: 0.5rem;
    overflow-y: auto;
    @include scrollbars(4px, $oc-gray-3, $oc-gray-1);
  }

  &__action-btn {
    background-color: white;
    width: 100%;
    font-size: 11px;
    padding: 0.3rem 0;
    transition: 0.2s;
    outline: none;
    border: 1px dashed $oc-gray-3;
    border-radius: 7px;

    &:hover {
      border-color: $oc-blue-3;
    }
  }

  &__add-card-btn {
    background-color: #ebecf0;
    width: 100%;
    font-size: 11px;
    padding: 0.3rem 0;
    transition: 0.2s;
    outline: none;
    border: none;
    border-radius: 0 0 7px 7px;
  }
}
</style>
