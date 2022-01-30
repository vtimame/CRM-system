<template>
  <div :style="{ cursor: 'pointer' }">
    <a-tooltip v-if="tooltip" placement="top">
      <template slot="title">
        <div>{{ user.surname }} {{ user.name }}</div>
        <div>({{ role_name }})</div>
      </template>
      <a-avatar class="user-avatar"
        >{{ user.surname[0] }}{{ user.name[0] }}</a-avatar
      >
    </a-tooltip>
  </div>
</template>

<script>
import { Avatar, Tooltip } from 'ant-design-vue';

export default {
  props: {
    user: {
      type: Object,
      required: true,
    },
    tooltip: {
      type: Boolean,
      required: false,
      default: true,
    },
  },
  computed: {
    role_name: function () {
      if (this.user.role_display !== null) {
        if (this.user.role_display.length > 0) return this.user.role_display;
      }

      return this.user.role.name;
    },
  },
  components: {
    'a-avatar': Avatar,
    'a-tooltip': Tooltip,
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.user-avatar {
  color: $oc-red-7;
  background-color: $oc-red-2;
  font-weight: 600;
}
</style>
