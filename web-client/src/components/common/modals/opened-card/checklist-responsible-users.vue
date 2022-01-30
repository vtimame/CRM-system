<template>
  <wrapper :options="options">
    <div class="edit-members">
      <div class="edit-members__header">
        Назначить ответственных
      </div>
      <div class="edit-members__body">
        <div class="edit-members__list">
          <div
            v-for="(id, index) in users"
            :key="index"
            class="edit-members__user"
            @click="clicked(id)"
          >
            <oy-avatar :data="getUser(id)" />
            <div class="ml-2 flex-grow-1">
              <div class="edit-members__username">
                {{ getUser(id).surname }} {{ getUser(id).name }}
              </div>
              <div class="edit-members__user-role">
                {{ getRoleName(getUser(id)) }}
              </div>
            </div>
            <div>
              <oy-feather-icon
                v-if="userInPoint(id)"
                type="check"
                size="15"
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
  computed: {
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    users: function() {
      return this.card.members;
    }
  },
  methods: {
    getUser(id) {
      return this.$store.getters["users/instance"](id);
    },
    getRoleName(user) {
      if (user.role_display) return user.role_display;
      else if (user.role) return user.role.name;
      else return "";
    },
    userInPoint(user_id) {
      if (
        this.options.checklist.points[this.options.point_index].responsible ===
        undefined
      )
        return Boolean(0);
      return (
        this.options.checklist.points[
          this.options.point_index
        ].responsible.find(el => el === user_id) !== undefined
      );
    },
    async updateChecklist(checklist) {
      await this.$store.dispatch(
        "kanban/card/checklists/updateChecklist",
        checklist
      );
    },
    async clicked(id) {
      const checklist = Object.assign({}, this.options.checklist);
      if (!checklist.points[this.options.point_index].responsible) {
        checklist.points[this.options.point_index].responsible = [id];
      } else {
        if (
          checklist.points[this.options.point_index].responsible.find(
            el => el === id
          ) !== undefined
        ) {
          checklist.points[
            this.options.point_index
          ].responsible = checklist.points[
            this.options.point_index
          ].responsible.filter(el => el !== id);
        } else checklist.points[this.options.point_index].responsible.push(id);
      }
      await this.updateChecklist(checklist);
      this.options.checklist = checklist;
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
  }

  &__creator-icon {
    stroke: $oc-yellow-7;
    fill: $oc-yellow-7;
  }
}
</style>
