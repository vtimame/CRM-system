<template>
  <form
    class="login-form d-flex justify-content-between flex-column"
    @submit.prevent="onSubmit"
  >
    <div class="d-flex justify-content-center">
      <logotype></logotype>
    </div>
    <div class="login-form__input">
      <oy-input
        v-if="!mobile_phone_is_checked"
        v-model="form.mobile_phone"
        :error="mobilePhoneError"
        prefix="+7"
        :error-center="true"
        :autofocus="true"
      />
      <oy-input
        v-else
        v-model="form.password"
        :error="passwordError"
        type="password"
        :error-center="true"
        ref="password"
      />
    </div>
    <div class="d-flex justify-content-center">
      <oy-button html-type="submit">Продолжить</oy-button>
    </div>
  </form>
</template>

<script>
import logotype from "../common/logotype.vue";

export default {
  name: "login-form",
  data: () => ({
    mobile_phone_is_checked: false,
    form: {
      mobile_phone: "",
      password: ""
    }
  }),
  computed: {
    mobilePhoneError: function() {
      const code = this.$store.getters["app/httpErrorCode"];
      if (code !== null && code === 0) return "Номер телефона не найден";
      return this.$store.getters["app/validateError"]("mobile_phone");
    },
    passwordError: function() {
      const code = this.$store.getters["app/httpErrorCode"];
      if (code !== null && code === 1) return "Не верный пин-код";
      return this.$store.getters["app/validateError"]("password");
    }
  },
  methods: {
    async onSubmit() {
      this.mobile_phone_is_checked
        ? await this.login()
        : await this.checkMobilePhone();
    },
    async checkMobilePhone() {
      await this.$store.dispatch("auth/checkMobilePhone", {
        mobile_phone: this.form.mobile_phone
      });
      this.mobile_phone_is_checked = true;
      setTimeout(() => {
        this.$refs.password.focus();
      }, 10);
    },
    async login() {
      await this.$store.dispatch("auth/login", this.form);
      this.$router.push({ name: "dashboard-page" });
    }
  },
  components: {
    logotype
  }
};
</script>

<style lang="scss" scoped>
.login-form {
  width: 350px;
  height: 350px;
  border-radius: 100%;
  background-color: rgba(255, 255, 255, 0.35);
  padding: 53px;
}
</style>
