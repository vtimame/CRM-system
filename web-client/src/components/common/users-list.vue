<template>
  <div class="h-100 w-100 d-flex flex-column">
    <oy-input class="mb-2" prefix="Поиск:" v-model="search_value">
      <oy-button slot="postfix" @click="$emit('createUser')">Создать</oy-button>
    </oy-input>
    <div class="users-list">
      <div v-if="users.length > 0">
        <div
          v-for="user in users"
          :key="user._id"
          class="d-flex align-items-center user"
          :class="{ 'user--selected': selected === user._id }"
          @click="$emit('select', user._id)"
        >
          <div>
            <oy-avatar :data="user" />
          </div>
          <div class="ml-2" :style="{ flex: 1 }">
            <div>{{ user.surname }} {{ user.name }}</div>
          </div>
        </div>
      </div>
      <div v-else class="users-list__empty">
        Пользователь не найден
      </div>
    </div>
  </div>
</template>

<script>
import _orderBy from "lodash/orderBy";

export default {
  props: {
    selected: {
      type: [String, null]
    }
  },
  data: () => ({
    search_value: ""
  }),
  computed: {
    users: function() {
      const list = _orderBy(this.$store.getters["users/all"], ["surname"]);
      if (this.search_value.trim().length === 0) {
        return list;
      }

      const re = new RegExp(this.search_value, "ig");
      return list.filter(
        el => el.name.match(re) || el.surname.match(re) || el.alias.match(re)
      );
    }
  },
  methods: {
    isSelected(id) {
      if (this.selected === null) return Boolean(false);
      if (typeof this.selected != "object") return id === this.selected;
      if (typeof this.selected === "object")
        return this.selected.find(el => el === id) !== undefined;
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.users-list {
  flex: 1;
  overflow-y: auto;
  @include scrollbars(0px, white, white);

  &__empty {
    height: 4rem;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: 600;
  }

  .user {
    padding: 0.3rem 1rem;
    cursor: pointer;
    transition: 0.2s;
    user-select: none;

    &:hover {
      background-color: $oc-gray-0;
    }

    &--selected {
      background-color: $oc-gray-0;
    }
  }
}
</style>
