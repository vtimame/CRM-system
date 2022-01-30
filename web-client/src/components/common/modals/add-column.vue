<template>
  <wrapper :options="options">
    <div class="board-settings">
      <div class="board-settings__header">Добавить колонку</div>
      <div class="board-settings__content">
        <form @submit.prevent="onSubmit">
          <div>
            <oy-input v-model="name" label="Название колонки" />
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
  computed: {
    board_id: function() {
      return this.$route.params.board_id;
    }
  },
  methods: {
    async onSubmit() {
      if (this.name.trim().length > 0) {
        await this.$store.dispatch("kanban/columns/store", {
          board_id: this.board_id,
          name: this.name
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
