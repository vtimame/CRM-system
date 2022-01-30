<template>
  <wrapper :options="options">
    <div class="edit-attachment">
      <div class="edit-attachment__header">
        <div class="edit-attachment__header-title">Изменить вложение</div>
      </div>
      <div class="column-settings__content p-2">
        <div class="mb-2">
          <oy-input
            :value="attachment_name"
            @input="onInput"
            label="Название"
          />
        </div>
        <div>
          <oy-button :block="true" @click="onClick">Сохранить</oy-button>
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "../modal";
import attachmentService from "../../../../services/attachmentService";

export default {
  mixins: [modal],
  computed: {
    attachment_name: function() {
      return this.options.attachment.title || this.options.attachment.name;
    }
  },
  methods: {
    onInput(value) {
      this.options.attachment.title = value;
    },
    async onClick() {
      const result = await attachmentService.updateAttachment(
        this.options.attachment
      );
      this.$store.commit(
        "kanban/card/attachments/updateAttachment",
        result.data
      );
      this.close();
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.edit-attachment {
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
