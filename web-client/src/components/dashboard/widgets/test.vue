<template>
  <div class="w-100 h-100 p-2">
    <div class="d-flex align-items-center">
      <oy-avatar
        :data="getUser(creators[index])"
        @click="index = index + 1"
      ></oy-avatar>
      <div class="ml-2">
        <div :style="{ fontSize: '13px', fontWeight: 600, lineHeight: '13px' }">
          {{ getUser(creators[index]).surname }}
          {{ getUser(creators[index]).name }}
        </div>
        <div :style="{ fontSize: '13px' }">
          {{ getUser(creators[index]).role.name }}
        </div>
      </div>
    </div>
    <div>Карточек: {{ cardsByCreator(creators[index]).length }}</div>
  </div>
</template>

<script>
export default {
  data: () => ({
    index: 0
  }),
  computed: {
    users: function() {
      return this.$store.getters["users/list"];
    },
    creators: function() {
      return this.$store.getters["kanban/cards/creators"];
    },
    cards: function() {
      return this.$store.getters["kanban/cards/list"];
    }
  },
  methods: {
    getUser(id) {
      return this.users.find(el => el._id === id);
    },
    cardsByCreator(id) {
      return this.cards.filter(el => el.creator_id === id);
    }
  }
};
</script>
