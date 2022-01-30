<template>
  <div class="members">
    <div v-if="members.length > 0" class="members__list d-flex flex-wrap">
      <oy-dropdown-menu
        class="mr-2 mb-2"
        v-for="member_id in members_list"
        :key="member_id"
      >
        <oy-avatar slot="trigger" :data="getUser(member_id)"></oy-avatar>
        <oy-dropdown-menu-item
          slot="item"
          v-if="columnScopeHas(card.board_id, card.column_id, 'set_card_lead')"
          @click="setLead(member_id)"
          >Назначить ведущим</oy-dropdown-menu-item
        >
        <oy-dropdown-menu-item
          slot="item"
          v-if="
            columnScopeHas(card.board_id, card.column_id, 'set_card_creator')
          "
          @click="setCreator(member_id)"
          >Назначить создателем</oy-dropdown-menu-item
        >
        <oy-dropdown-menu-item
          slot="item"
          v-if="
            columnScopeHas(
              card.board_id,
              card.column_id,
              'delete_card_members'
            ) &&
              userIsNotCreator(member_id) &&
              userIsNotLead(member_id)
          "
          @click="exceptFromCard(member_id)"
          >Исключить из карточки</oy-dropdown-menu-item
        >
      </oy-dropdown-menu>
      <oy-circle-button
        class="mr-2 mb-2"
        v-if="
          columnScopeHas(card.board_id, card.column_id, 'add_card_members') ||
            columnScopeHas(card.board_id, card.column_id, 'delete_card_members')
        "
        @click="
          $modal.open({
            name: 'edit-members',
            width: '400px'
          })
        "
      >
        <oy-feather-icon type="plus" size="16" />
      </oy-circle-button>
      <oy-circle-button
        class="mr-2 mb-2"
        v-if="showLeaveButton"
        @click="
          $store.dispatch('kanban/cards/deleteMember', {
            card_id: card._id,
            member_id: user._id
          })
        "
      >
        <oy-feather-icon type="log-out" size="14" />
      </oy-circle-button>
    </div>
  </div>
</template>

<script>
import cardService from "../../../../services/cardService";

export default {
  props: {
    members: {
      type: Array,
      default: () => []
    }
  },
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    members_list: function() {
      return this.members.filter(
        el => el !== this.card.creator_id && el !== this.card.lead_id
      );
    },
    userIsMember: function() {
      return this.members.find(el => el === this.user._id);
    },
    showLeaveButton: function() {
      return (
        this.userIsMember &&
        this.userIsNotCreator(this.user._id) &&
        this.userIsNotLead(this.user._id) &&
        this.columnScopeHas(
          this.card.board_id,
          this.card.column_id,
          "leave_from_card"
        )
      );
    }
  },
  methods: {
    userIsNotLead: function(id) {
      return this.card.lead_id !== id;
    },
    userIsNotCreator: function(id) {
      return this.card.creator_id !== id;
    },
    getUser(user_id) {
      return this.$store.getters["users/instance"](user_id);
    },
    setCreator(member_id) {
      cardService.updateCard(this.card._id, { creator_id: member_id });
      cardService.sendCreatorNotification(this.card._id, {
        creator_id: member_id
      });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.card._id,
        payload: { creator_id: member_id }
      });
    },
    setLead(member_id) {
      cardService.updateCard(this.card._id, { lead_id: member_id });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.card._id,
        payload: { lead_id: member_id }
      });
    },
    exceptFromCard(member_id) {
      this.$store.dispatch("kanban/cards/deleteMember", {
        card_id: this.card._id,
        member_id
      });
      this.$echo
        .private(`board.${this.$route.params.board_id}`)
        .whisper("deleteMember", {
          card_id: this.card._id,
          member_id
        });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.members {
  &__list {
    &--empty {
      background-color: $oc-gray-1;
      display: flex;
      justify-content: center;
      font-weight: 600;
    }
  }
}
</style>
