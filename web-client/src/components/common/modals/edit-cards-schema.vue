<template>
  <wrapper :options="options">
    <div class="edit-cards-schema">
      <div class="edit-cards-schema__header">
        <div class="edit-cards-schema__header-title">Компоненты карточек</div>
        <div class="edit-cards-schema__header-subtitle">
          {{ options.column.name }}
        </div>
      </div>
      <div class="column-settings__content p-2">
        <div v-for="item in cardComponents" :key="item.name">
          <oy-checkbox
            class="mb-2"
            @input="onItemChange($event, item.name)"
            :value="schemaHas(item.name)"
            >{{ item.label }}</oy-checkbox
          >
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import cardComponentsMixin from "../cardComponentsMixin";
import columnService from "../../../services/columnService";

export default {
  mixins: [modal, cardComponentsMixin],

  methods: {
    onItemChange(value, name) {
      let schema = [...this.options.column.cards_schema];
      const index = schema.findIndex(el => el === name);
      if (index !== -1) schema.splice(index, 1);
      else schema.push(name);
      columnService.updateColumn(
        Object.assign(
          {},
          { column_id: this.options.column._id },
          { cards_schema: schema }
        )
      );
      this.options.column.cards_schema = schema;
    },
    schemaHas(name) {
      return (
        this.options.column.cards_schema.find(el => el === name) !== undefined
      );
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.edit-cards-schema {
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
