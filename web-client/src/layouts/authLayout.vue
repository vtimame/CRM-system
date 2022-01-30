<template>
  <div class="auth-layout">
    <router-view></router-view>
  </div>
</template>

<script>
import bg from "../assets/images/login-bg.jpg";

export default {
  name: "auth-layout",
  data: () => ({
    bg: bg
  })
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.auth-layout {
  height: 100vh;
  background-color: $oc-gray-0;
}
</style>
