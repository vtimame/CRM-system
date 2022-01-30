<template>
  <div class="phonebook-page">
    <div v-for="department in phonebook" :key="department._id">
      <div class="department-name py-1">{{ department.name }}</div>
      <div v-for="division in department.divisions" :key="division._id">
        <div class="division-name py-1" v-if="division.name !== 'Директорат'">
          {{ division.name }}
        </div>
        <div
          class="d-flex user-row"
          v-for="user in division.users"
          :key="user._id"
        >
          <div class="user-col" :style="{ flex: 1 }">
            {{ user.role ? user.role.name : "" }}
          </div>
          <div
            class="user-col d-flex align-items-center"
            :style="{ flex: 1.5 }"
          >
            <oy-avatar :data="user" />
            <div class="ml-2">{{ user.surname }} {{ user.name }}</div>
          </div>
          <div class="user-col" :style="{ flex: 1 }">
            {{ user.public_phone }}
          </div>
          <div
            class="user-col justify-content-center"
            :style="{ flex: 0.3, fontWeight: 600 }"
          >
            {{ user.office_phone }}
          </div>
          <div class="user-col" :style="{ flex: 1 }">
            {{ $utils.formatPhone(user.mobile_phone) }}
          </div>
          <div class="user-col" :style="{ flex: 1 }">
            <a :href="`mailto:${user.email}`">{{ user.email }}</a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import store from "../store/index";

export default {
  async beforeRouteEnter(to, from, next) {
    await store.dispatch("app/phonebook/loadList");
    next();
  },
  computed: {
    phonebook: function() {
      return this.$store.getters["app/phonebook/list"];
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.phonebook-page {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: white;
  overflow-y: auto;
  @include scrollbars(4px, $oc-gray-5, $oc-gray-3);
  font-size: 13px;
}

.department-name {
  text-align: center;
  font-weight: 600;
  background-color: $oc-gray-8;
  color: white;
}

.division-name {
  text-align: center;
  font-weight: 600;
  background-color: $oc-gray-6;
  color: white;
}

.user-row {
  border-bottom: 1px solid $oc-gray-3;
  transition: 0.25s;

  &:hover {
    background-color: $oc-gray-1;
  }

  &:last-child {
    border-bottom: none;
  }
}

.user-col {
  display: flex;
  align-items: center;
  border-right: 1px solid $oc-gray-3;
  padding: 0.3rem 0.7rem;

  &:last-child {
    border-right: none;
  }
}
</style>
