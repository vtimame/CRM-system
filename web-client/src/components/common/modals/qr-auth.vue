<template>
  <wrapper :options="options" :emitCLick="true" @click="close">
    <div class="qr-auth">
      <div class="qr-auth__header d-flex align-items-center">
        <div>
          <span>Войти с помощью QR-кода</span>
        </div>
      </div>
      <div class="qr-auth__content">
        <div class="d-flex justify-content-center">
          <qr :value="qrData" :options="{ width: 200 }"></qr>
        </div>
        <div class="mt-2 text-center px-3 pb-2">
          Отсканируйте этот QR-код в своем мобильном приложении для быстрой
          авторизации
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import VueQrcode from "@chenfengyuan/vue-qrcode";

export default {
  mixins: [modal],
  data: () => ({
    qrData: null
  }),
  async mounted() {
    try {
      const qrData = await this.$axios.get("auth/user/qr");
      this.qrData = JSON.stringify(qrData.data);
    } catch (e) {
      console.log(e);
      throw e;
    }
  },
  components: {
    qr: VueQrcode
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.qr-auth {
  &__header {
    /*font-size: 1rem;*/
    font-weight: 600;
    padding: 0.5rem 1rem;
    border-bottom: 1px solid $oc-gray-3;
    display: flex;
    justify-content: space-between;
  }

  &__device {
    padding: 0.3rem 1rem;
    border-bottom: 1px solid $oc-gray-0;

    &:last-child {
      border-bottom: none;
    }

    .platform-icon {
      width: 38px;
      height: auto;
    }

    &-data {
      font-weight: 600;
      line-height: 13px;
    }

    &-meta {
      font-size: 12px;
    }
  }
}
</style>
