<template>
  <div class="header-nav">
    <!--    <oy-circle-button class="mr-2" @click="$emit('open-drawer')">-->
    <!--      <oy-feather-icon type="help-circle" size="16" />-->
    <!--    </oy-circle-button>-->
    <oy-badge color="red" :visible="new_notifications_length > 0">
      <oy-avatar :data="user" @click="$emit('open-notifications')" />
    </oy-badge>
  </div>
</template>

<script>
export default {
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    new_notifications_length: function() {
      return this.$store.getters["user/notifications/notRead"].length;
    }
  }
};
</script>

<style lang="scss" scoped>
.header-nav {
  display: flex;
}
</style>
