<template>
  <wrapper :options="options">
    <div class="other-column-settings">
      <div class="other-column-settings__header">
        <div class="other-column-settings__header-title">
          Прочее
        </div>
        <div class="other-column-settings__header-subtitle">
          {{ options.column.name }}
        </div>
      </div>
      <div class="other-column-settings__content">
        <div class="mb-2">
          <oy-checkbox
            :value="column.track_activity"
            @input="onChange($event, 'track_activity')"
            >Отслеживать активность в карточках</oy-checkbox
          >
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import _set from "lodash/set";

export default {
  mixins: [modal],
  computed: {
    column: function() {
      return this.options.column;
    }
  },
  methods: {
    async onChange(value, key) {
      const result = await this.$store.dispatch("kanban/columns/update", {
        column_id: this.column._id,
        [key]: value
      });
      this.options.column[key] = result.data[key];
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.other-column-settings {
  &__header {
    padding: 0.5rem 1rem;
  }

  &__content {
    padding: 0.5rem 1rem;
    min-height: 500px;
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
