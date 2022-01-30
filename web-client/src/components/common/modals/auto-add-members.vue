<template>
  <wrapper :options="options">
    <div class="auto-add-members">
      <div class="auto-add-members__header">
        <div class="auto-add-members__header-title">
          Автоматическое добавление участников
        </div>
        <div class="auto-add-members__header-subtitle">
          {{ options.column.name }}
        </div>
      </div>
      <div class="auto-add-members__content">
        <oy-search-select
          :options="potencial_users"
          label="fio"
          value="Выберите пользователя"
          :clearable="false"
          @input="onUserSelected"
        >
          <template v-slot:option="option">
            <div class="d-flex align-items-center">
              <div class="mr-2">
                <oy-avatar :data="option" />
              </div>
              <div>
                <span>{{ option.surname }} {{ option.name }}</span>
              </div>
            </div>
          </template>
        </oy-search-select>
        <div class="mt-2">
          <oy-action-button
            v-for="(id, index) in autoadd_users_id"
            :key="index"
          >
            {{ getUserInstance(id).surname }} {{ getUserInstance(id).name }}
            <oy-feather-icon
              slot="postfix"
              type="x"
              size="16"
              @click="onDeleteUser(id)"
            />
          </oy-action-button>
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";

export default {
  mixins: [modal],
  data: () => ({}),
  computed: {
    autoadd_users_id: function() {
      return this.options.column?.autoadd_users
        ? this.options.column.autoadd_users
        : [];
    },
    users: function() {
      return this.$store.getters["users/list"];
    },
    potencial_users: function() {
      let users = [];

      this.users.forEach(el => {
        if (!this.autoadd_users_id.find(id => el._id === id)) {
          users.push(
            Object.assign({}, el, { fio: `${el.surname} ${el.name}` })
          );
        }
      });

      return users;
    }
  },
  methods: {
    async onUserSelected(user) {
      const result = await this.$store.dispatch("kanban/columns/update", {
        column_id: this.options.column._id,
        autoadd_users: [...this.autoadd_users_id, user._id]
      });
      this.options.column.autoadd_users = result.data.autoadd_users;
    },
    async onDeleteUser(id) {
      const list = [...this.autoadd_users_id];
      const index = list.findIndex(el => el === id);
      if (index !== -1) list.splice(index, 1);
      const result = await this.$store.dispatch("kanban/columns/update", {
        column_id: this.options.column._id,
        autoadd_users: list
      });
      this.options.column.autoadd_users = result.data.autoadd_users;
    },
    getUserInstance(id) {
      return this.$store.getters["users/instance"](id);
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.auto-add-members {
  &__header {
    padding: 0.5rem 1rem;
  }

  &__content {
    padding: 0.5rem 1rem;
    min-height: 500px;
  }

  &__header {
    border-bottom: 1px solid $oc-gray-3;

    &-title {
      font-size: 1rem;
      line-height: 1rem;
      font-weight: 600;
    }

    &-subtitle {
      font-size: 11px;
      line-height: 11px;
    }
  }
}
</style>
