<template>
  <wrapper :options="options">
    <div class="board-settings">
      <div class="board-settings__header">Добавить доску</div>
      <div class="board-settings__content">
        <form @submit.prevent="onSubmit">
          <div>
            <oy-input v-model="name" label="Название доски" />
          </div>
          <div class="mt-2">
            <oy-button
              type="success"
              :block="true"
              :disabled="name.trim().length === 0"
              html-type="submit"
              >Сохранить</oy-button
            >
          </div>
        </form>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";

export default {
  mixins: [modal],
  data: () => ({
    name: ""
  }),
  methods: {
    async onSubmit() {
      if (this.name.trim().length > 0) {
        const board = await this.$store.dispatch(
          "kanban/boards/storeBoard",
          this.name
        );
        this.$router.push({
          name: "board-page",
          params: { board_id: String(board._id) }
        });
        this.close();
      }
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
