<template>
  <wrapper :options="options" :emitCLick="true" @click="close">
    <div class="manage-tokens">
      <div class="manage-tokens__header d-flex align-items-center">
        <div>
          <span>Устройства</span>
        </div>
        <a
          :style="{ fontWeight: 500, fontSize: '13px' }"
          href="#"
          @click.prevent="logout"
          >Выйти со всех устройств</a
        >
      </div>
      <div class="manage-tokens__content">
        <div
          v-for="token in tokens"
          :key="token._id"
          class="manage-tokens__device d-flex align-items-center"
        >
          <img :src="getIcon(token.device.platform)" class="platform-icon" />
          <div class="ml-2" :style="{ flex: 1 }">
            <div class="manage-tokens__device-data">
              {{ token.device.platform }}
              {{ token.device.device_name }}
              {{ token.device.browser }}
              {{ token.device.browser_version }}
            </div>
            <div class="manage-tokens__device-meta">
              {{ token.device.ip }} - {{ $utils.formatDate(token.created_at) }}
            </div>
          </div>
          <a
            :style="{ fontWeight: 500, fontSize: '13px' }"
            href="#"
            @click.prevent="logout($event, token._id)"
            >Выйти</a
          >
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";

import androidIcon from "../../../assets/images/AndroidOS.svg";
import appleIcon from "../../../assets/images/apple.svg";
import linuxIcon from "../../../assets/images/linux.svg";

export default {
  mixins: [modal],
  computed: {
    tokens: function() {
      return this.$store.getters["user/tokens"].filter(
        el => el.device.device_type !== "robot"
      );
    }
  },
  methods: {
    getIcon(platform) {
      switch (platform) {
        case "AndroidOS":
          return androidIcon;
        case "iOS":
          return appleIcon;
        case "Linux":
          return linuxIcon;
      }
    },
    logout(event, id = null) {
      if (!id) console.log(this.tokens.map(el => el._id));
      else console.log(id);
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.manage-tokens {
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
