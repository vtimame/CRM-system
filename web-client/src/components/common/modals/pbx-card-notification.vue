<template>
  <wrapper :options="options">
    <div class="board-settings">
      <div class="board-settings__header">Входящий звонок</div>
      <div class="board-settings__content">
        <div class="mb-2">
          <div class="text-center">
            <div :style="{ fontWeight: 600 }">
              {{ options.card.title }} -
              <span :style="{ color: $oc.green['600'] }"
                >{{ options.contact.surname }} {{ options.contact.name }}
                {{ options.contact.patronymic }}</span
              >
            </div>
          </div>
        </div>
        <oy-button type="success" :block="true" @click="openCard"
          >Открыть карточку</oy-button
        >
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";

export default {
  mixins: [modal],
  methods: {
    async openCard() {
      if (this.$route.query.card_id) {
        this.$modal.close("opened-card");
      }

      let options = { query: { card_id: this.options.card._id } };
      if (this.$route.name !== "board-page") {
        options.name = "board-page";
        options.params = { board_id: this.options.card.board_id };
      } else if (this.$route.params.board_id !== this.options.card.board_id) {
        options.params = { board_id: this.options.card.board_id };
      }

      await this.$router.push(options);

      this.$modal.open({
        name: "opened-card",
        width: "850px",
        position: "top",
        card_id: this.$route.query.card_id
      });

      this.close();
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
