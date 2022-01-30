<template>
  <div
    class="notification"
    @click="pushInCard"
    :class="{ 'notification--not-read': !data.read_at }"
  >
    <div class="notification__initiator">
      <oy-badge :visible="false">
        <oy-avatar :data="initiator" size="64" />
      </oy-badge>
    </div>
    <div class="notification__message">
      <div>
        <span class="notification__initiator__name">
          {{ initiator.surname }} {{ initiator.name }}
        </span>
        <span>
          упомянул вас в карточке
        </span>
        <span class="notification__card__name">{{ card.title }}</span>
      </div>
      <div class="notification__date">
        {{ $utils.formatDate(data.created_at) }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    data: {
      type: Object,
      required: true
    }
  },
  computed: {
    initiator: function() {
      return this.$store.getters["users/instance"](
        this.data.event.initiator_id
      );
    },
    card: function() {
      return this.$store.getters["kanban/cards/rawInstance"](
        this.data.event.card_id
      );
    }
  },
  methods: {
    async pushInCard() {
      if (!this.data.read_at) {
        await this.$store.dispatch(
          "user/notifications/markAsRead",
          this.data._id
        );
      }

      let options = { query: { card_id: this.card._id } };
      // await this.$store.dispatch("kanban/card/loadCard", this.card._id);
      if (this.$route.name !== "board-page") {
        options.name = "board-page";
        options.params = { board_id: this.card.board_id };
      } else if (this.$route.params.board_id !== this.card.board_id) {
        options.params = { board_id: this.card.board_id };
      }

      await this.$router.push(options);
      this.$emit("close-notifications");
      if (this.$route.name === "board-page") {
        this.$modal.open({
          name: "opened-card",
          width: "850px",
          position: "top"
        });
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.notification {
  font-size: 13px;
  line-height: 14px;
  padding: 0.5rem;
  border-bottom: 1px solid $oc-gray-1;
  display: flex;
  align-items: center;
  cursor: pointer;

  &__date {
    font-size: 11px;
    margin-top: 0.3rem;
  }

  &--not-read {
    background-color: $oc-yellow-0;
    transition: 0.2s ease-in-out;

    &:hover {
      background-color: $oc-yellow-1;
    }
  }

  &__message {
    margin-left: 0.5rem;
  }

  &__initiator {
    &__name {
      font-weight: 600;
    }
  }

  &__card {
    &__name {
      font-weight: 600;
    }
  }
}
</style>
