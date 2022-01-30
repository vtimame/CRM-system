<template>
  <wrapper :options="options">
    <div class="board-labels">
      <div class="board-labels__header d-flex">
        <div
          class="mr-2"
          :style="{ cursor: 'pointer' }"
          v-if="add_label_mode"
          @click="add_label_mode = false"
        >
          <oy-feather-icon
            type="arrow-left"
            size="18"
            :style="{ marginTop: '-4px' }"
          />
        </div>
        <div>Метки</div>
      </div>
      <div class="board-labels__content">
        <div v-if="add_label_mode">
          <oy-input
            placeholder="Новая метка..."
            ref="label_title"
            label="Название"
            v-model="newLabel.name"
            :error="newLabelError"
          />
          <div class="mt-3 mb-2">Цвет</div>
          <div class="d-flex flex-wrap">
            <div
              class="label__color-sample"
              :class="{
                'label__color-sample--disabled': colorAlreadyIsUsed(oc[color])
              }"
              :style="{
                backgroundColor: oc[color]
              }"
              v-for="(color, i) in openColors"
              :key="i"
            >
              <div
                class="label__color-sample__overlay  d-flex align-items-center justify-content-center"
                @click="newLabel.color = oc[color]"
              >
                <transition name="fade">
                  <oy-feather-icon
                    v-if="newLabel.color === oc[color]"
                    type="check"
                    size="16"
                  />
                </transition>
              </div>
            </div>
          </div>
          <oy-button :block="true" @click="saveNewLabel">Сохранить</oy-button>
        </div>
        <div v-else>
          <div
            v-if="!this.board.labels || this.board.labels.length === 0"
            class="d-flex flex-column align-items-center"
          >
            <img :src="poor" width="120" />
            <div>Здесь пока нет ни одной метки</div>
            <div>
              <a href="#" @click.prevent="addNewLabel"
                >Но вы можете добавить новую</a
              >
            </div>
          </div>
          <div v-else>
            <div v-for="(label, i) in board.labels" :key="i">
              <oy-label
                :name="label.name"
                :closable="true"
                :color="label.color"
                :large="true"
                :hover="true"
                @click="onLabelSelect(i)"
                @close="onLabelDelete(i)"
                class="mb-1"
              />
            </div>
            <oy-button :block="true" class="mt-2" @click="addNewLabel"
              >Добавить новую метку</oy-button
            >
          </div>
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import poor from "../../../assets/images/poor.svg";
import cardService from "@/services/cardService";

export default {
  mixins: [modal],
  data: () => ({
    poor: poor,
    add_label_mode: false,
    newLabelError: "",
    newLabel: {
      name: "",
      color: ""
    },
    oc: {
      green: "#61bd4f",
      yellow: "#f2d600",
      orange: "#ff9f1a",
      red: "#eb5a46",
      violet: "#c377e0",
      blue: "#0079bf",
      lightBlue: "#00c2e0",
      teal: "#51e898",
      pink: "#ff78cb",
      darkGrey: "#344563",
      lightGrey: "#b3bac5"
    }
  }),
  computed: {
    board_id: function() {
      return this.$route.params.board_id;
    },
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    board: function() {
      return this.$store.getters["kanban/boards/instance"](this.board_id);
    },
    openColors: function() {
      return Object.keys(this.oc);
    }
  },
  methods: {
    colorAlreadyIsUsed(color) {
      if (!this.board.labels) return Boolean(0);
      return this.board.labels.find(el => el.color === color) !== undefined;
    },
    addNewLabel() {
      this.add_label_mode = true;
      setTimeout(() => {
        this.$refs.label_title.focus();
      }, 10);
    },
    async saveNewLabel() {
      this.newLabelError = "";
      if (this.newLabel.name === "") {
        this.newLabelError = "Введите название метки";
      } else if (this.newLabel.color === "") {
        this.newLabelError = "Выберите цвет метки";
      } else {
        const boardInstance = Object.assign({}, this.board);
        if (boardInstance.labels) boardInstance.labels.push(this.newLabel);
        else boardInstance.labels = [this.newLabel];
        await this.$store.dispatch(
          "kanban/boards/updateBoard",
          Object.assign({}, boardInstance, { board_id: this.board_id })
        );
        this.newLabel = { name: "", color: "" };
        this.add_label_mode = false;
      }
    },
    async onLabelDelete(index) {
      const boardInstance = Object.assign({}, this.board);
      boardInstance.labels.splice(index, 1);
      await this.$store.dispatch(
        "kanban/boards/updateBoard",
        Object.assign({}, boardInstance, { board_id: this.board_id })
      );
    },
    onLabelSelect(index) {
      const label = this.board.labels[index];
      const cardInstance = Object.assign({}, this.card);
      if (cardInstance.labels) cardInstance.labels.push(label);
      else cardInstance.labels = [label];
      cardService.updateCard(this.card._id, { labels: cardInstance.labels });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.card._id,
        payload: { labels: cardInstance.labels }
      });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.board-labels {
  &__header,
  &__content {
    padding: 0.5rem 1rem;
    font-size: 13px;

    .label__color-sample {
      width: 46px;
      height: 32px;
      margin: 0 7px 7px 0;
      flex: 0 0 auto;
      border-radius: 3px;
      color: white;
      cursor: pointer;
      position: relative;

      &--disabled {
        display: none;
      }

      &__overlay {
        position: absolute;
        border-radius: 3px;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: transparent;
        transition: 0.25s ease-in-out;

        &:hover {
          background-color: rgba(255, 255, 255, 0.3);
        }
      }
    }
  }

  &__header {
    font-size: 1rem;
    font-weight: 600;
    border-bottom: 1px solid $oc-gray-3;
  }
}
</style>
