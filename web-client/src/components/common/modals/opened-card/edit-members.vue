<template>
  <wrapper :options="options">
    <div class="edit-members">
      <div class="edit-members__header">
        Добавить или удалить участников карточки
      </div>
      <div class="edit-members__body">
        <div
          class="edit-members__search"
          :class="{ 'edit-members__search--focused': search.focused }"
        >
          <oy-input
            v-model="search.value"
            placeholder="Поиск"
            @focus="search.focused = true"
            @blur="search.focused = false"
            ref="input"
            :input-style="{
              paddingLeft: '1rem',
              border: 'none'
            }"
          />
        </div>
        <div class="edit-members__list">
          <div
            v-for="user in users"
            :key="user._id"
            class="edit-members__user"
            @click="onCLick(user)"
          >
            <oy-avatar :data="user" />
            <div class="ml-2 flex-grow-1">
              <div class="edit-members__username">
                {{ user.surname }} {{ user.name }}
              </div>
              <div class="edit-members__user-role">
                {{ getRoleName(user) }}
              </div>
            </div>
            <div>
              <oy-feather-icon
                v-if="isCreator(user._id)"
                type="star"
                size="12"
                class="edit-members__creator-icon mr-2"
              />
              <oy-feather-icon
                v-if="userHasInvited(user._id)"
                type="target"
                size="10"
                class="edit-members__invited-icon"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "../modal";
import wrapper from "../wrapper";
import _orderBy from "lodash/orderBy";

export default {
  mixins: [modal],
  data: () => ({
    search: {
      value: "",
      focused: false
    }
  }),
  mounted() {
    setTimeout(() => {
      this.$refs.input.focus();
    }, 10);
  },
  computed: {
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    users: function() {
      const list = this.$store.getters["users/list"];
      if (this.search.value.trim().length === 0) {
        return _orderBy(list, ["surname"]);
      }

      const re = new RegExp(this.search.value, "ig");
      return _orderBy(
        list.filter(
          el => el.surname.match(re) || el.name.match(re) || el.alias.match(re)
        ),
        ["surname"]
      );
    }
  },
  methods: {
    isCreator(id) {
      return this.card.creator_id === id;
    },
    isLead(id) {
      return this.card.lead_id === id;
    },
    userHasInvited(id) {
      return this.card.members.find(el => el === id);
    },
    onCLick(user) {
      const canAdd = this.columnScopeHas(
        this.card.board_id,
        this.card.column_id,
        "add_card_members"
      );
      const canDelete = this.columnScopeHas(
        this.card.board_id,
        this.card.column_id,
        "delete_card_members"
      );

      // if (!this.isCreator(user._id) && !this.isLead(user._id)) {
      if (canDelete && this.userHasInvited(user._id))
        this.deleteMember(user._id);
      else {
        if (canAdd) this.addMember(user);
      }
      // } else {
      //   alert("Нельзя исключить создателя или ведущего карточки!");
      // }
    },
    addMember(user) {
      this.$store.dispatch("kanban/cards/addMember", {
        card_id: this.$route.query.card_id,
        member_id: user._id
      });
      this.$echo.private(`board.${this.card.board_id}`).whisper("addMember", {
        card_id: this.$route.query.card_id,
        member_id: user._id
      });
    },
    deleteMember(id) {
      this.$store.dispatch("kanban/cards/deleteMember", {
        card_id: this.$route.query.card_id,
        member_id: id
      });
      this.$echo
        .private(`board.${this.card.board_id}`)
        .whisper("deleteMember", {
          card_id: this.$route.query.card_id,
          member_id: id
        });
    },
    getRoleName(user) {
      if (user.role_display) return user.role_display;
      else if (user.role) return user.role.name;
      else return "";
    }
  },
  components: {
    wrapper
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.edit-members {
  font-size: 13px;

  &__header {
    border-bottom: 1px solid $oc-gray-3;
    font-weight: 600;
    padding: 0.5rem 1rem;
  }

  &__list {
    max-height: 500px;
    overflow-y: auto;
    @include scrollbars(3px, $oc-gray-5, $oc-gray-3);
  }

  &__search {
    border-bottom: 1px solid $oc-gray-3;
    transition: 0.2s;

    &--focused {
      border-color: $oc-blue-5;
    }
  }

  &__user {
    display: flex;
    align-items: center;
    padding: 0.3rem 1rem;
    transition: 0.2s;
    cursor: pointer;

    &:hover {
      background-color: $oc-gray-2;
    }
  }

  &__username {
    font-weight: 600;
    line-height: 13px;
  }

  &__user-role {
    font-size: 12px;
    line-height: 12px;
  }

  &__invited-icon {
    stroke: $oc-green-5;
    fill: $oc-green-5;
  }

  &__creator-icon {
    stroke: $oc-yellow-7;
    fill: $oc-yellow-7;
  }
}
</style>
