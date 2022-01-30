<template>
  <div
    class="oy-avatar"
    @click="$emit('click')"
    :style="{
      width: `${size}px`,
      height: `${size}px`,
      fontSize: `${fontSize}px`
    }"
  >
    <div v-if="user.avatar === null || load_error">
      {{ userSurname[0] }}{{ userName[0] }}
    </div>
    <img
      v-else
      :src="avatarPath"
      class="img-fluid"
      @error="load_error = true"
      :style="{ borderRadius: '100%' }"
    />
  </div>
</template>

<script>
export default {
  props: {
    size: {
      type: [String, Number],
      default: 32
    },
    fontSize: {
      type: [String, Number],
      default: 14
    },
    data: {
      type: Object
    }
  },
  data: () => ({
    load_error: false,
    default: {
      name: "User",
      surname: "Unknown",
      avatar: null
    }
  }),
  computed: {
    user: function() {
      return this.data ? this.data : this.default;
    },
    userName: function() {
      return this.data?.name;
    },
    userSurname: function() {
      return this.data?.surname;
    },
    avatarPath: function() {
      return (
        process.env.VUE_APP_API_URL +
        "/avatars/" +
        this.user.alias +
        "/thumbnails/w_64_" +
        this.user.avatar_name
      );
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.oy-avatar {
  font-weight: 600;
  border-radius: 100%;
  background-color: $oc-red-2;
  cursor: pointer;
  transition: 0.2s;
  display: flex;
  justify-content: center;
  align-items: center;
  color: $oc-red-8;
  user-select: none;

  /*&:hover {
    box-shadow: 0 0 0 0.15rem $oc-red-1;
    background-color: $oc-red-3;
  }*/
}
</style>
