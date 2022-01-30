<template>
  <div class="divisions">
    <section class="divisions__list">
      <div class="divisions__list__header">
        <div class="divisions__list__title">Отделы</div>
        <!--        <oy-feather-icon type="plus" size="18" />-->
      </div>
      <div class="divisions__list__content">
        <oy-action-button
          v-for="division in divisions"
          :key="division._id"
          @click="onDivisionClick(division._id)"
        >
          {{ division.name }}
        </oy-action-button>
      </div>
    </section>
    <section class="divisions__instance col-lg-4" v-if="instance">
      <div class="divisions__instance__header">
        <div class="divisions__instance__name">{{ instance.name }}</div>
        <div class="divisions__instance__department-name">
          {{ instance.department.name }}
        </div>
      </div>
      <div class="mt-2">
        <div :style="{ fontWeight: 600 }">Руководители</div>
        <div class="my-2">
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
        </div>
        <div v-if="managers.length > 0">
          <div
            class="d-flex align-items-center mb-2"
            v-for="(manager_id, i) in managers"
            :key="manager_id"
          >
            <oy-avatar :data="getUser(manager_id)" size="42" />
            <div class="ml-2 flex-grow-1">
              <div :style="{ fontWeight: 600, lineHeight: '13px' }">
                {{ getUser(manager_id).surname }}
                {{ getUser(manager_id).name }}
              </div>
              <div :style="{ fontSize: '13px' }">
                {{ getUser(manager_id).role.name }}
              </div>
            </div>
            <div>
              <oy-feather-icon
                type="trash"
                size="14"
                @click="onDeleteManager(i)"
                :style="{ cursor: 'pointer' }"
              />
            </div>
          </div>
        </div>
        <div v-else>Этим отделом ни кто не руководит</div>
      </div>
    </section>
    <section class="divisions__instance divisions__instance--empty" v-else>
      Выберите отдел
    </section>
  </div>
</template>

<script>
export default {
  computed: {
    divisions: function() {
      return this.$store.getters["divisions/list"];
    },
    instance: function() {
      return this.$store.getters["divisions/instance"](
        this.$route.query.division_id
      );
    },
    managers: function() {
      return this.instance.managers || [];
    },
    users: function() {
      return this.$store.getters["users/list"];
    },
    potencial_users: function() {
      let users = [];

      this.users.forEach(el => {
        if (!this.managers.find(id => el._id === id)) {
          users.push(
            Object.assign({}, el, { fio: `${el.surname} ${el.name}` })
          );
        }
      });

      return users;
    }
  },
  methods: {
    onDivisionClick(id) {
      this.$router.push({ query: { division_id: id } });
    },
    async onUserSelected(user) {
      await this.$store.dispatch("divisions/update", {
        id: this.instance._id,
        payload: { managers: [...this.managers, user._id] }
      });
    },
    getUser(id) {
      return this.$store.getters["users/instance"](id);
    },
    async onDeleteManager(index) {
      const managers = [...this.managers];
      managers.splice(index, 1);
      console.log(managers);
      await this.$store.dispatch("divisions/update", {
        id: this.instance._id,
        payload: { managers: managers }
      });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.divisions {
  background-color: white;
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  overflow-y: hidden;
  display: flex;
  user-select: none;

  &__list {
    height: 100%;
    width: 400px;
    display: flex;
    flex-direction: column;
    border-right: 1px solid $oc-gray-3;

    &__header {
      padding: 0.5rem 1rem;
      border-bottom: 1px solid $oc-gray-1;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    &__title {
      font-weight: 600;
    }

    &__content {
      flex: 1;
      padding: 0.5rem 1rem;
      overflow-y: auto;
      @include scrollbars(4px, $oc-gray-5, $oc-gray-3);
    }
  }

  &__instance {
    flex: 1;
    padding: 0.5rem 1rem;

    &--empty {
      display: flex;
      justify-content: center;
      align-items: center;
      font-weight: 600;
    }

    &__name {
      font-size: 1.2rem;
      line-height: 1.2rem;
      font-weight: 600;
    }

    &__department-name {
      font-size: 0.8rem;
    }
  }
}
</style>
