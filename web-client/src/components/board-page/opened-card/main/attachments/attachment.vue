<template>
  <div class="attachment">
    <div
      class="attachment__thumbnail"
      :style="thumbnailStyle"
      @click="onThumbnailClick"
    >
      <div v-if="!isImage">.{{ extension }}</div>
    </div>
    <div class="attachment__info">
      <div>
        <div class="attachment__name">
          {{ attachment.title || attachment.name }}
        </div>
        <div>
          <div class="attachment__user">
            {{ attachment.user.surname }} {{ attachment.user.name }}
            <span :style="{ fontSize: '11px' }">{{
              $utils.formatDate(attachment.created_at)
            }}</span>
          </div>
        </div>
      </div>
      <oy-feather-icon
        type="more-vertical"
        class="attachment__more-icon"
        size="16"
        @click="dropdownOpen"
      ></oy-feather-icon>
      <transition name="fade">
        <div v-if="dropdown_visible" class="attachment__dropdown">
          <div
            v-if="
              isImage &&
                columnScopeHas(card.board_id, card.column_id, 'edit_card_cover')
            "
            class="attachment__dropdown__item"
            @click="setCover"
          >
            Сделать обложкой
          </div>
          <div
            v-if="
              attachment.user_id === user._id || user._id === card.creator_id
            "
            class="attachment__dropdown__item"
            @click="
              $modal.open({
                name: 'edit-attachment',
                width: '350px',
                position: 'center',
                attachment
              })
            "
          >
            Переименовать
          </div>
          <div
            @click="deleteAttachment"
            v-if="
              columnScopeHas(
                card.board_id,
                card.column_id,
                'delete_card_attachments'
              )
            "
            class="attachment__dropdown__item attachment__dropdown__delete-item"
          >
            Удалить
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<script>
import cardService from "../../../../../services/cardService";

export default {
  props: {
    attachment: {
      type: Object
    }
  },
  data: () => ({
    image_extensions: ["jpg", "png", "jpeg", "png", "gif"],
    dropdown_visible: false
  }),
  computed: {
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    user: function() {
      return this.$store.getters["user/instance"];
    },
    thumbnailStyle: function() {
      let backgroundImage = "none";
      if (this.isImage) {
        backgroundImage = `url(${this.$api.url}/${this.$api.attachments_path}/${this.card._id}/thumbnails/w_300_${this.attachment.name})`;
      }
      return { backgroundImage: backgroundImage };
    },
    extension: function() {
      const splitName = this.attachment.name.split(".");
      return splitName[splitName.length - 1];
    },
    isImage: function() {
      return Boolean(this.image_extensions.find(el => el === this.extension));
    }
  },
  methods: {
    onThumbnailClick() {
      if (this.isImage) this.$emit("open-lightbox");
      else {
        window.open(
          `${this.$api.url}/${this.$api.attachments_path}/${this.card._id}/${this.attachment.name}`,
          "_blank"
        );
      }
    },
    dropdownOpen() {
      this.dropdown_visible = true;
      window.addEventListener("click", this.clickController, true);
    },
    dropdownClose() {
      this.dropdown_visible = false;
      window.removeEventListener("click", this.clickController, true);
    },
    clickController(event) {
      if (event.target.closest(".attachment__dropdown") === null) {
        this.dropdownClose();
      }
    },
    async setCover() {
      await cardService.updateCard(this.card._id, {
        cover_id: this.attachment._id
      });
      this.$store.commit("kanban/cards/setCover", {
        card_id: this.$route.query.card_id,
        attachment: this.attachment
      });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.$route.query.card_id,
        payload: { cover_id: this.attachment._id }
      });
      // this.$echo
      //         .private(`board.${this.$route.params.board_id}`)
      //         .whisper("setCardData", { card_id, payload });
      this.dropdownClose();
    },
    deleteAttachment() {
      if (this.card.cover_id === this.attachment._id) {
        this.$store.commit("kanban/cards/setCover", {
          card_id: this.$route.query.card_id,
          attachment: null
        });
        this.$store.commit("kanban/cards/setCardData", {
          card_id: this.$route.query.card_id,
          payload: { cover_id: null }
        });
      }

      this.$store.dispatch("kanban/cards/deleteAttachment", {
        card_id: this.$route.query.card_id,
        instance: this.attachment
      });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.attachment {
  display: flex;
  align-items: center;
  border-bottom: 1px solid $oc-gray-3;

  &:last-child {
    border-bottom: none;
  }

  &__thumbnail {
    width: 100px;
    height: 50px;
    background-color: $oc-gray-2;
    background-size: cover;
    background-position: center center;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: 600;
    cursor: pointer;
  }

  &__name {
    font-weight: 600;
  }

  &__user,
  &__created-at {
    font-size: 12px;
    line-height: 13px;
  }

  &__info {
    flex: 1;
    padding: 0.5rem;
    display: flex;
    justify-content: space-between;
    position: relative;
  }

  &__more-icon {
    color: $oc-gray-7;
    cursor: pointer;
  }

  &__dropdown {
    position: absolute;
    right: 5px;
    top: 0;
    background-color: white;
    border: 1px solid $oc-gray-3;
    padding: 0.2rem 0;
    z-index: 2;

    &__item {
      padding: 0.3rem 1rem;
      transition: 0.2s;

      &:hover {
        background-color: $oc-gray-1;
        cursor: pointer;
      }
    }

    &__delete-item {
      padding: 0.3rem 1rem;
      transition: 0.2s;

      &:hover {
        color: white;
        background-color: $oc-red-5;
        cursor: pointer;
      }
    }
  }
}
</style>
