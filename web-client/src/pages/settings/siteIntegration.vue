<template>
  <div class="pbx-page h-100">
    <div class="container-fluid py-2">
      <div class="pbx-page__title">Интеграция с сайтом</div>
      <div class="row">
        <div class="col-lg-4 col-md-6 pt-3">
          <div>Колонка для заявок</div>
          <oy-search-select
            :options="columns"
            label="name"
            :value="
              tickets_column !== null ? tickets_column : 'Выберите колонку'
            "
            :clearable="false"
            @input="onChange('tickets_column_id', $event._id)"
          >
            <template v-slot:option="option">
              <div class="d-flex align-items-center">
                <div>
                  <span>{{ option.board.name }} / {{ option.name }}</span>
                </div>
              </div>
            </template>
          </oy-search-select>

          <div class="mt-2">Создатели карточки</div>
          <oy-search-select
            :options="potential_roles"
            label="name"
            value="Выберите роль"
            :clearable="false"
            @input="
              onChange('tickets_creator_roles', [
                ...tickets_creator_roles,
                $event._id
              ])
            "
          />
          <div class="mt-2">
            <oy-action-button v-for="id in tickets_creator_roles" :key="id">
              <oy-feather-icon
                slot="postfix"
                type="x"
                size="16"
                @click="onDeleteRole(id)"
              />
              {{ $store.getters["roles/instance"](id).name }}</oy-action-button
            >
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import store from "../../store";
export default {
  async beforeRouteEnter(to, from, next) {
    await store.dispatch("app/site/loadSettings");
    await store.dispatch("kanban/columns/loadRawColumns");
    await store.dispatch("users/loadUsers");
    next();
  },
  computed: {
    columns: function() {
      const list = this.$store.getters["kanban/columns/rawList"];
      return list.filter(el => el.board);
    },
    roles: function() {
      return this.$store.getters["roles/list"];
    },
    potential_roles: function() {
      return this.roles.filter(
        el => !this.tickets_creator_roles.find(o => o === el._id)
      );
    },
    tickets_column: function() {
      if (!this.settings.tickets_column_id) return null;
      return this.columns.find(
        el => el._id === this.settings.tickets_column_id
      );
    },
    tickets_creator_roles: function() {
      return this.settings.tickets_creator_roles || [];
    },
    settings: function() {
      return this.$store.getters["app/site/settings"];
    }
  },
  methods: {
    async onChange(name, value) {
      await this.$store.dispatch("app/site/updateSettings", { [name]: value });
    },
    async onDeleteRole(id) {
      await this.onChange(
        "tickets_creator_roles",
        this.tickets_creator_roles.filter(el => el !== id)
      );
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.pbx-page {
  background-color: white;

  &__title {
    color: $oc-gray-8;
    font-size: 1.2rem;
    line-height: 1.2rem;
    font-weight: 600;
  }

  &__subtitle {
    font-weight: 600;
  }
}
</style>
