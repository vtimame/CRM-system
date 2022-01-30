<template>
  <wrapper :options="options">
    <div class="filter-cards">
      <div class="filter-cards__header">Фильтр</div>
      <div class="filter-cards__content">
        <div
          class="filter-cards__content__user d-flex align-items-center"
          @click="clicked(user._id)"
          v-for="user in creators"
          :key="user._id"
        >
          <div class="mr-2">
            <oy-avatar :data="user"></oy-avatar>
          </div>
          <div class="flex-grow-1">
            <div class="user-name">{{ user.surname }} {{ user.name }}</div>
            <div class="user-role">{{ user.role.name }}</div>
          </div>
          <oy-feather-icon
            v-if="selected === user._id"
            type="circle"
            :stroke="$oc.green[7]"
            :fill="$oc.green[7]"
            size="12"
          />
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";

export default {
  mixins: [modal],
  computed: {
    creators: function() {
      const creators = this.$store.getters["kanban/cards/creators"];
      return this.users.filter(user => {
        return creators.find(id => id === user._id);
      });
    },
    selected: function() {
      return this.$store.getters["kanban/cards/selected_creator"];
    },
    users: function() {
      return this.$store.getters["users/list"];
    }
  },
  methods: {
    clicked(id) {
      this.$store.commit(
        "kanban/cards/setSelectedId",
        this.selected === id ? null : id
      );
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.filter-cards {
  &__header {
    font-size: 1rem;
    font-weight: 600;
    border-bottom: 1px solid $oc-gray-3;
    padding: 0.5rem 1rem;
  }

  &__content {
    user-select: none;
    padding: 0.2rem 0;

    &__user {
      padding: 0.3rem 1rem;
      border-bottom: 1px solid $oc-gray-0;
      cursor: pointer;
      transition: 0.2s;

      &:hover {
        background-color: $oc-gray-1;
      }

      .user-name {
        font-weight: 600;
        font-size: 13px;
        line-height: 13px;
      }

      .user-role {
        font-size: 12px;
      }
    }
  }
}
</style>
