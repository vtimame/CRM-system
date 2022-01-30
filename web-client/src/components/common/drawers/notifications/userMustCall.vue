<template>
  <div
    class="notification"
    @click="pushInCard"
    :class="{ 'notification--not-read': !data.read_at }"
  >
    <div class="notification__initiator">
      <oy-circle-button size="64">
        <oy-feather-icon type="phone" />
      </oy-circle-button>
    </div>
    <div class="notification__message">
      <div>
        <span>
          У вас запланирован звонок по карточке
        </span>
        <span class="notification__card__name">{{ card.title }}</span>
        <span>&nbsp;{{ data.event.event_dt }}</span>
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
    },
    old_column: function() {
      return this.$store.getters["kanban/columns/instance"](
        this.data.event.old_column_id
      );
    },
    new_column: function() {
      return this.$store.getters["kanban/columns/instance"](
        this.data.event.new_column_id
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
