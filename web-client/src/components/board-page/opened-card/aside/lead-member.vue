<template>
  <div class="lead-member py-1">
    <div v-if="member" class="d-flex align-items-center">
      <oy-avatar
        v-if="!isLead"
        :data="member"
        :style="{ flex: '0 0 auto' }"
      ></oy-avatar>
      <oy-dropdown-menu v-else>
        <oy-avatar
          slot="trigger"
          :data="member"
          :style="{ flex: '0 0 auto' }"
        ></oy-avatar>
        <oy-dropdown-menu-item
          v-if="
            columnScopeHas(card.board_id, card.column_id, 'unset_card_lead')
          "
          slot="item"
          @click="unsetLead(member._id)"
          >Снять ведущего</oy-dropdown-menu-item
        >
      </oy-dropdown-menu>
      <div class="ml-2">
        <div class="lead-member__name">
          {{ member.surname }} {{ member.name }}
        </div>
        <div class="lead-member__position">
          {{ position }}
        </div>
      </div>
    </div>
    <div v-else>
      Пользователь не найден
    </div>
  </div>
</template>

<script>
import cardService from "../../../../services/cardService";

export default {
  props: {
    member: {
      type: Object
    },
    isLead: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    position: function() {
      if (this.member.role_display) {
        return this.member.role_display;
      } else {
        return this.member.role.name;
      }
    },
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    }
  },
  methods: {
    unsetLead(member_id) {
      cardService.updateCard(this.card._id, { lead_id: null });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.card._id,
        payload: { lead_id: null }
      });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
.lead-member {
  &__name {
    font-weight: 600;
    line-height: 13px;
  }

  &__position {
    font-size: 12px;
    line-height: 13px;
  }
}
</style>
