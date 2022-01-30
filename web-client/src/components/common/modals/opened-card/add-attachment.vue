<template>
  <wrapper :options="options">
    <div class="add-attachment">
      <div class="add-attachment__header">
        Загрузить вложение
      </div>
      <div class="add-attachment__body">
        <file-pond
          labelIdle='Перетащите файлы сюда<br><span class="add-attachment__link">или загрузите вручную</span>'
          name="file"
          allowMultiple="true"
          allowImagePreview="false"
          maxFileSize="25MB"
          ref="pond"
          :server="server"
        ></file-pond>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "../modal";
import vueFilePond from "vue-filepond";
import FilePondPluginImagePreview from "filepond-plugin-image-preview";
const FilePond = vueFilePond(FilePondPluginImagePreview);

export default {
  mixins: [modal],
  components: {
    FilePond
  },
  computed: {
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    server: function() {
      return {
        url: `${this.$api.url}/kanban/cards/${this.card._id}/attachments`,
        revert: (uniqueFileId, load, error) => {
          console.log(uniqueFileId, load, error);
        },
        process: {
          headers: {
            Authorization: `Bearer ${this.$store.getters["user/token"]}`
          },
          onload: attachment => {
            this.$store.dispatch("kanban/cards/pushAttachment", {
              card_id: this.$route.query.card_id,
              instance: JSON.parse(attachment)
            });
          }
        }
      };
    }
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.add-attachment {
  &__header {
    font-weight: 600;
    padding: 0.5rem 1rem;
  }

  .filepond--panel-root {
    background-color: transparent;
  }

  .filepond--list {
    margin-top: 0.5rem;
  }

  .filepond--drop-label {
    background-color: $oc-gray-0;
    border: 3px dashed $oc-gray-3;
    border-radius: 0;
    cursor: pointer;
    transition: 0.2s ease-in-out;

    label {
      cursor: pointer;
    }

    &:hover {
      border-color: $oc-blue-5;
    }
  }

  &__link {
    font-size: 13px !important;
    text-decoration: underline;
  }
}
</style>
