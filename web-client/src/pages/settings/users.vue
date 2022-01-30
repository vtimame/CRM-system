<template>
  <div class="users-page__wrapper">
    <div class="users-page">
      <div class="users__list">
        <users-list
          :selected="selected_user"
          @createUser="createUser"
          @select="userSelected"
        />
      </div>
      <div class="users__instance py-4 container" v-if="selected_user">
        <div class="d-flex align-items-center justify-content-between">
          <div class="d-flex align-items-center">
            <div
              class="users__instance__avatar mr-3"
              :style="{ backgroundImage: `url(${avatar})` }"
            ></div>
            <div>
              <div class="users__instance__name mb-2 d-flex align-items-center">
                <div
                  v-if="user.deleted_at"
                  class="mr-1 d-flex align-items-center justify-content-center"
                >
                  <oy-feather-icon type="lock" size="18" stroke="red" />
                </div>
                <span>{{ user.surname }} {{ user.name }}</span>
              </div>
              <div class="users__instance__position">
                <span v-if="user_division">{{ user_division }}</span>
                <span v-else class="text-danger">Отдел не указан</span>
                <span v-if="user_role"> - {{ user_role }}</span>
              </div>
              <div class="users__instance__email">
                <span v-if="user.email">{{ user.email }}</span>
                <span v-else class="text-danger">Почта не указана</span>
              </div>
            </div>
          </div>
        </div>
        <div class="mt-3" :style="{ width: '700px' }">
          <div class="row mb-2">
            <div class="col-12">
              <oy-checkbox
                checkbox-position="left"
                :value="user.onVacation || false"
                @input="onChange('onVacation', $event)"
                >В отпуске</oy-checkbox
              >
            </div>
          </div>
          <div class="row mb-2">
            <div class="col-6">
              <oy-input
                label="Фамилия"
                :value="user.surname"
                @change="onChange('surname', $event)"
              />
            </div>
            <div class="col-6">
              <oy-input
                label="Имя"
                :value="user.name"
                @change="onChange('name', $event)"
              />
            </div>
          </div>
          <div class="row mb-2">
            <div class="col-6">
              <oy-input
                label="Дата рождения"
                :value="user.birthday"
                @change="onChange('birthday', $event)"
              />
            </div>
            <div class="col-6">
              <oy-input
                label="Алиас"
                :value="user.alias"
                @change="onChange('alias', $event)"
              />
            </div>
          </div>
          <div class="row mb-2">
            <div class="col-6">
              <div>Пол</div>
              <oy-select :value="user.sex" @change="onChange('sex', $event)">
                <option value="0">Мужской</option>
                <option value="1">Женский</option>
              </oy-select>
            </div>
            <div class="col-6">
              <oy-input
                label="Email"
                :value="user.email"
                @change="onChange('email', $event)"
              />
            </div>
          </div>
          <div class="row mb-2">
            <div class="col-6">
              <oy-input
                :value="user.mobile_phone"
                prefix="+7"
                label="Мобильный телефон"
                @change="onChange('mobile_phone', $event)"
              />
            </div>
            <div class="col-6">
              <oy-input
                label="Внутренний номер"
                :value="user.office_phone"
                @change="onChange('office_phone', $event)"
              />
            </div>
          </div>
          <div class="row mb-2">
            <div class="col-12">
              <div>Отдел</div>
              <oy-search-select
                :options="divisions"
                label="name"
                :value="divisions.find(el => el._id === user.division_id)"
                :clearable="false"
                @input="onChangeSelect('division_id', $event)"
              />
            </div>
            <div class="col-12">
              <div>Отдел</div>
              <oy-search-select
                :options="roles"
                label="name"
                :value="roles.find(el => el._id === user.role_id)"
                :clearable="false"
                @input="onChangeSelect('role_id', $event)"
              />
            </div>
          </div>
          <!--          <div class="row mb-2">-->
          <!--            <div class="col-12 mb-2">-->
          <!--              График отпусков-->
          <!--            </div>-->
          <!--            <div class="col-12">-->
          <!--              <v-calendar-->
          <!--                @dayclick="onDayClick"-->
          <!--                :attributes="[-->
          <!--                  {-->
          <!--                    key: 'today',-->
          <!--                    highlight: true,-->
          <!--                    fillMode: 'light',-->
          <!--                    dates-->
          <!--                  }-->
          <!--                ]"-->
          <!--              />-->
          <!--            </div>-->
          <!--          </div>-->
          <div class="row mb-2">
            <div class="col-12 d-flex justify-content-end">
              <oy-button
                v-if="!user.deleted_at"
                type="danger"
                @click="disableUser"
                >Отключить</oy-button
              >
              <oy-button v-else type="primary" @click="enableUser"
                >Включить</oy-button
              >
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import usersList from "../../components/common/users-list.vue";

export default {
  data: () => ({
    selected_user: null,
    selectDateRange: null,
    dates: []
  }),
  mounted() {
    if (!this.systemScopeHas("edit_users")) {
      this.$router.push({ name: "not-found-page" });
    }
  },
  computed: {
    user: function() {
      return this.$store.getters["users/loadedInstance"];
    },
    divisions: function() {
      return this.$store.getters["divisions/list"];
    },
    user_division: function() {
      return this.divisions.find(el => el._id === this.user?.division_id)?.name;
    },
    user_role: function() {
      return this.user?.role?.name;
    },
    roles: function() {
      return this.$store.getters["roles/list"];
    },
    avatar: function() {
      return (
        process.env.VUE_APP_API_URL +
        "/avatars/" +
        this.user.alias +
        "/" +
        this.user.avatar_name
      );
    }
  },
  methods: {
    async userSelected(id) {
      await this.$store.dispatch("users/loadUser", id);
      this.selected_user = id;
    },
    onDayClick(event) {
      if (!this.selectDateRange) {
        this.dates.push({
          start: new Date(event.dateTime),
          end: new Date(event.dateTime)
        });
        this.selectDateRange = this.dates.length - 1;
      } else {
        this.dates[this.selectDateRange].end = new Date(event.dateTime);
        this.selectDateRange = null;
      }
    },
    onChange(key, value) {
      this.updateUserData({ [key]: value });
    },
    onChangeSelect(key, object) {
      this.updateUserData({ [key]: object._id });
    },
    disableUser() {
      this.updateUserData({
        deleted_at: moment().format("YYYY-MM-DD HH:mm:ss")
      });
    },
    enableUser() {
      this.updateUserData({
        deleted_at: null
      });
    },
    updateUserData(payload) {
      this.$store.dispatch("users/updateLoadedUser", payload);
    },
    async createUser() {
      const user = await this.$store.dispatch("users/createUser");
      await this.$store.dispatch("users/loadUsers");
      this.selected_user = user._id;
    }
  },
  components: {
    usersList
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.users-page {
  background-color: white;
  height: 100%;
  display: flex;

  &__wrapper {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    padding: 12px;
  }
}

.users {
  &__list {
    width: 400px;
    border-right: 1px solid $oc-gray-3;
  }

  &__instance {
    padding: 0.5rem 1rem;

    &__role {
      font-size: 14px;
      font-weight: 500;
      line-height: 1rem;
    }

    &__avatar {
      width: 100px;
      height: 100px;
      border-radius: 100%;
      background-size: cover;
      background-repeat: no-repeat;
      border: 1px solid $oc-gray-1;
    }

    &__name {
      font-weight: 600;
      font-size: 1.3rem;
      line-height: 1.3rem;
    }

    &__position,
    &__email {
      font-size: 1rem;
      line-height: 1rem;
    }
  }
}
</style>
