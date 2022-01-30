<template>
  <div class="login-view" :style="{ backgroundImage: `url(${bg})` }">
    <div class="form-wrapper">
      <logotype class="logotype"></logotype>
      <div class="form-wrapper__form-group form-wrapper__form-input">
        <a-input
          ref="input"
          v-model="value"
          :class="{ 'has-error': hasError }"
          :type="mobilePhoneIsChecked ? 'password' : 'text'"
          :allowClear="true"
          @keydown="onKeyDown"
        >
          <span slot="prefix" v-if="!mobilePhoneIsChecked">+7</span>
          <a-tooltip placement="top" v-else slot="prefix">
            <template slot="title">
              <span>Изменить номер телефона</span>
            </template>
            <a-icon
              type="arrow-left"
              :style="{ cursor: 'pointer' }"
              @click="onArrowClick"
            />
          </a-tooltip>
        </a-input>
        <transition name="fade" mode="in-out">
          <small class="form-wrapper__form-error" v-if="hasError">
            <span v-if="!mobilePhoneIsChecked">Номер телефона не найден</span>
            <span v-else>Не верный пин-код</span>
          </small>
        </transition>
      </div>
      <div class="form-wrapper__form-group">
        <a-button
          class="form-wrapper__form-button"
          type="primary"
          @click="onSubmit"
          >Продолжить</a-button
        >
      </div>
    </div>
  </div>
</template>

<script>
import bg from '../static/login-bg.jpg';
import logotype from '../components/logotype.vue';
import { Button, Input, Form, Icon, Tooltip } from 'ant-design-vue';

export default {
  data: () => ({
    bg: bg,
    value: '',
    mobilePhoneIsChecked: false,
    form: {
      mobile_phone: '',
      password: '',
    },
  }),
  computed: {
    hasError: function () {
      return (
        this.$store.getters['app/http_error'](0) !== undefined ||
        this.$store.getters['app/http_error'](1) !== undefined
      );
    },
  },
  mounted() {
    this.$refs.input.focus();
  },
  components: {
    logotype,
    'a-input': Input,
    'a-button': Button,
    'a-form-item': Form.Item,
    'a-icon': Icon,
    'a-tooltip': Tooltip,
  },
  methods: {
    onArrowClick() {
      this.value = this.form.mobile_phone;
      this.mobilePhoneIsChecked = false;
      this.$refs.input.focus();
    },
    onKeyDown(event) {
      const regExp = new RegExp(/^\d+$/);
      if (event.which === 116) return false;
      if (event.which === 13) this.onSubmit();
      if (event.which !== 8 && event.which !== 13) {
        if (!regExp.test(event.key)) {
          event.preventDefault();
        }
      }
    },
    onSubmit() {
      this.mobilePhoneIsChecked ? this.login() : this.checkMobilePhone();
    },
    async login() {
      this.form.password = this.value;
      try {
        await this.$store.dispatch('auth/login', this.form);
        this.value = '';
        this.$router.push({ name: 'dashboard-page' });
      } catch (e) {
        console.log(e);
      }
    },
    async checkMobilePhone() {
      if (this.value.length < 10) return false;
      this.form.mobile_phone = this.value;
      try {
        await this.$store.dispatch(
          'auth/checkMobilePhone',
          this.form.mobile_phone
        );
        this.value = '';
        this.mobilePhoneIsChecked = true;
      } catch (e) {
        console.log(e);
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.login-view {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-size: cover;
  background-position: center center;

  .form-wrapper {
    width: 350px;
    height: 350px;
    background-color: rgba(255, 255, 255, 0.7);
    border-radius: 100%;
    padding: 53px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;

    .logotype {
      fill: #cc0000;
      width: 115px;
    }

    &__form-group {
      display: flex;
      justify-content: center;
      width: 100%;
    }

    &__form-input {
      position: relative;
    }

    &__form-error {
      color: #f5222d;
      position: absolute;
      bottom: -20px;
    }
  }
}
</style>
