<template>
  <div class="card-attachments">
    <div v-if="attachments.length > 0">
      <attachment
        v-for="(attachment, i) in attachments_array"
        :key="attachment._id"
        :attachment="attachment"
        @open-lightbox="openLightbox(i)"
      ></attachment>
      <div
        v-if="attachments.length > 3"
        :style="{ fontWeight: 600, cursor: 'pointer' }"
        class="w-100 text-center py-1"
        @click="show_all_attachments = !show_all_attachments"
      >
        {{
          `${
            show_all_attachments ? "Скрыть" : "Показать все вложения"
          } вложения`
        }}
      </div>
      <vue-easy-lightbox
        :visible="lightbox_is_visible"
        :imgs="images"
        :index="lightbox_index"
        @hide="lightbox_is_visible = false"
      ></vue-easy-lightbox>
    </div>
    <div v-else class="card-attachments__empty">
      Здесь пока нет ни одного вложения
    </div>
  </div>
</template>

<script>
import attachment from "./attachments/attachment.vue";

export default {
  props: {
    attachments: {
      type: Array,
      default: () => []
    }
  },
  data: () => ({
    lightbox_index: 0,
    lightbox_is_visible: false,
    show_all_attachments: false,
    image_extensions: ["jpg", "png", "jpeg", "png", "gif"]
  }),
  computed: {
    attachments_array: function() {
      let attachments = [...this.attachments];
      if (this.show_all_attachments) return this.attachments;
      return attachments.slice(0, 3);
    },
    images: function() {
      const names = this.attachments.map(el => el.name);
      const images = names.filter(el => {
        const splitName = el.split(".");
        const ext = splitName[splitName.length - 1];
        return this.image_extensions.find(o => o === ext);
      });
      return images.map(
        el =>
          `${this.$api.url}/${this.$api.attachments_path}/${this.$route.query.card_id}/${el}`
      );
    }
  },
  methods: {
    openLightbox(index) {
      this.lightbox_index = index;
      this.lightbox_is_visible = true;
    }
  },
  components: {
    attachment
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-attachments {
  background-color: $oc-gray-1;
  border-radius: 3px;
  color: $oc-gray-8;
  margin-top: 0.3rem;

  &__empty {
    padding: 1rem 0;
    display: flex;
    justify-content: center;
    font-weight: 600;
  }
}
</style>
