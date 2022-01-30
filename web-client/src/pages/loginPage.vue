<template>
  <div
    class="container-fluid h-100 py-3 d-flex align-items-center justify-content-center"
  >
    <form class="login-form" @submit.prevent="onSubmit">
      <div class="d-flex align-items-center justify-content-between">
        <logotype width="90"></logotype>
        <transition name="fade">
          <a
            v-if="passwordSent"
            href="#"
            @click.prevent="passwordSent = false"
            :style="{ fontSize: '13px' }"
            >Назад</a
          >
        </transition>
      </div>
      <transition
        :name="`auth-input-${passwordSent ? 'right' : 'left'}-transition`"
        mode="out-in"
      >
        <div v-if="!passwordSent" class="mt-4" key="login">
          <oy-input
            :autofocus="true"
            placeholder="Email, alias или номер телефона"
            v-model="form.login"
          />
        </div>
        <div v-else :class="[`mt-${user ? '2' : '4'}`]" key="password">
          <div v-if="user" class="mb-2 d-flex align-items-center">
            <div
              class="user-avatar"
              :style="{ backgroundImage: `url(${avatarsUrl})` }"
            ></div>
            <div class="ml-2">
              <div class="user-name">{{ user.surname }} {{ user.name }}</div>
              <div class="user-email">{{ user.email }}</div>
            </div>
          </div>
          <div>
            <oy-input
              :autofocus="true"
              placeholder="Пин-код"
              type="password"
              v-model="form.password"
              @keydown.esc="passwordSent = false"
            />
          </div>
        </div>
      </transition>
      <div class="mt-4">
        <oy-button
          type="success"
          html-type="submit"
          :font-weight="600"
          :block="true"
          :disabled="
            (!passwordSent && form.login.length === 0) ||
              (passwordSent && form.password.length === 0)
          "
          >Продолжить</oy-button
        >
      </div>
    </form>
  </div>
</template>

<script>
import logotype from "../components/common/logotype.vue";
import { Notification } from "element-ui";
import "element-ui/lib/theme-chalk/notification.css";
import "element-ui/lib/theme-chalk/icon.css";

export default {
  name: "login-page",
  data: () => ({
    form: {
      login: "",
      password: ""
    },
    passwordSent: false,
    passwordInputsDisabled: false,
    passwordInputStyle: {
      textAlign: "center",
      fontWeight: 600
    }
  }),
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    avatarsUrl: function() {
      return (
        process.env.VUE_APP_API_URL +
        "/avatars/" +
        this.user.alias +
        "/thumbnails/w_64_" +
        this.user.avatar_name
      );
    }
  },
  components: {
    logotype
  },
  methods: {
    async onSubmit() {
      try {
        this.passwordSent ? await this.logIn() : await this.findUser();
      } catch (e) {
        Notification.error({
          title: "Ошибка",
          dangerouslyUseHTMLString: true,
          message: "Неверный логин или пароль",
          showClose: false,
          duration: 5000
        });
      }
    },
    async findUser() {
      await this.$store.dispatch("user/sendPassword", this.form.login);
      this.passwordSent = true;
      Notification.success({
        title: "Учетная запись найдена",
        dangerouslyUseHTMLString: true,
        message: `На ваш телефон: <strong>${this.user.mobile_phone}</strong> отправлено сообщение с новым пин-кодом`,
        showClose: false,
        duration: 5000
      });
    },
    async logIn() {
      await this.$store.dispatch("user/logIn", this.form);
      await this.$router.push({ name: "dashboard-page" });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.login-form {
  width: 350px;
  border-radius: 4px;
  box-shadow: 0 1px 0 0 #d7d8db, 0 0 0 1px #e3e4e8;
  color: $oc-gray-8;
  padding: 1rem;
  background-color: white;

  .user-avatar {
    width: 42px;
    height: 42px;
    border-radius: 100%;
    background-color: $oc-gray-3;
    background-size: cover;
    background-repeat: no-repeat;
  }

  .user-name {
    font-weight: 600;
    line-height: 13px;
  }

  .user-email {
    font-size: 12px;
  }
}
</style>
