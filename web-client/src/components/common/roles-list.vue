<template>
  <div>
    <oy-input class="mb-2" prefix="Поиск:" v-model="search_value" />
    <div class="roles-list">
      <div v-if="roles.length > 0">
        <oy-action-button
          v-for="role in roles"
          :key="role._id"
          :selected="isSelected(role._id)"
          @click="$emit('selected', role._id)"
          >{{ role.name }}</oy-action-button
        >
      </div>
      <div v-else class="roles-list__empty">
        Такой роли не существует
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    selected: {
      type: [String, Array, null]
    },
    additional: {
      type: Array,
      default: () => []
    }
  },
  computed: {
    roles: function() {
      const list = this.additional.concat(this.$store.getters["roles/list"]);
      if (this.search_value.trim().length === 0) {
        return list;
      }

      const re = new RegExp(this.search_value, "ig");
      return list.filter(el => el.name.match(re));
    }
  },
  data: () => ({
    search_value: ""
  }),
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

.roles-list {
  max-height: 500px;
  overflow-y: auto;
  @include scrollbars(0px, white, white);

  &__empty {
    height: 4rem;
    display: flex;
    justify-content: center;
    align-items: center;
    font-weight: 600;
  }
}
</style>
