<template>
  <wrapper :options="options">
    <div class="column-settings">
      <div class="column-settings__header">
        <div class="column-settings__header-title">Настройки колонки</div>
        <div class="column-settings__header-subtitle">
          {{ options.column.name }}
        </div>
      </div>
      <div class="column-settings__content">
        <oy-action-button @click="openColumnPermissionsModal"
          >Права</oy-action-button
        >
        <oy-action-button @click="onAutoaddClick"
          >Автоматическое добавление участников</oy-action-button
        >
        <oy-action-button @click="onOtherClick">Прочее</oy-action-button>
        <oy-action-button @click="openCardsSchemaModal"
          >Компоненты карточек</oy-action-button
        >
        <oy-action-button :disabled="true"
          >Условия перемещения</oy-action-button
        >
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import cardComponentsMixin from "../cardComponentsMixin";

export default {
  mixins: [modal, cardComponentsMixin],
  mounted() {
    if (this.options.column.cards_schema === undefined) {
      this.options.column.cards_schema = this.cardComponents.map(el => el.name);
    }
  },
  methods: {
    async onAutoaddClick() {
      this.$modal.open({
        name: "auto-add-members",
        width: "450px",
        position: "top",
        column: this.options.column
      });
    },
    async onOtherClick() {
      this.$modal.open({
        name: "other-column-settings",
        width: "450px",
        position: "top",
        column: this.options.column
      });
    },
    async openCardsSchemaModal() {
      this.$modal.open({
        name: "edit-cards-schema",
        width: "350px",
        position: "top",
        column: this.options.column
      });
    },
    async openColumnPermissionsModal() {
      await this.$store.commit(
        "settings/columnsPermissions/setColumnId",
        this.options.column._id
      );
      this.$modal.open({
        name: "column-permissions",
        width: "650px",
        position: "top",
        column: this.options.column
      });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.column-settings {
  &__header {
    padding: 0.5rem 1rem;
  }

  &__content {
    padding: 0.5rem 1rem;
  }

  &__header {
    border-bottom: 1px solid $oc-gray-3;

    &-title {
      font-size: 1rem;
      line-height: 1rem;
      font-weight: 600;
    }

    &-subtitle {
      font-size: 11px;
      line-height: 11px;
    }
  }
}
</style>
