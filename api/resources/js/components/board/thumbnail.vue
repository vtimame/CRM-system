<template>
  <div class="card-thumbnail" @click="onThumbnailClick(data.id)">
    <thumb-section>
      <div class="card-thumbnail__title">{{ data.title }}</div>
    </thumb-section>
    <thumb-section v-if="data.address" title="Адрес">
      <span>{{ data.address.street }}</span>
      <span v-if="data.address.street_num"
        >, д. {{ data.address.street_num }}</span
      >
    </thumb-section>
    <thumb-section v-if="data.contacts.length > 0" title="Контакты">
      <div
        v-for="contact in data.contacts"
        :key="contact.id"
        class="card-thumbnail__contact"
      >
        {{ contact.surname }} {{ contact.name }}
      </div>
    </thumb-section>
    <thumb-section v-if="data.members.length > 0" title="Участники">
      <div class="card-thumbnail__members">
        <div
          class="card-thumbnail__member"
          v-for="member in data.members"
          :key="member.id"
        >
          <user-avatar :user="member" />
        </div>
      </div>
    </thumb-section>
    <thumb-section v-if="data.members.length > 0" title="Debug">
      <div>Position: {{ data.position }}</div>
      <div>created_at: {{ formatDate(data.created_at) }}</div>
      <div>updated_at: {{ formatDate(data.updated_at) }}</div>
    </thumb-section>
  </div>
</template>

<script>
import moment from 'moment';
import thumbSection from './thumbnail/section.vue';
import userAvatar from '../default-layout/user-avatar';

export default {
  props: {
    data: {
      type: Object,
      required: true,
    },
  },
  components: {
    userAvatar,
    thumbSection,
  },
  methods: {
    formatDate(date) {
      return moment(date).format('DD.MM.YYYY H:mm:ss');
    },
    async onThumbnailClick(card_id) {
      await this.$router.push({
        query: Object.assign({}, this.$route.query, { card_id }),
      });
      await this.$store.dispatch('kanban/card/loadCard', card_id);
      this.$modal.open({
        name: 'opened-card',
        width: '850px',
        position: 'top',
      });
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.card-thumbnail {
  background-color: white;
  margin-bottom: 1rem;
  cursor: pointer;
  user-select: none;
  font-size: 13px;

  &__title {
    font-weight: 600;
  }

  &__contact {
    color: $oc-green-7;
  }

  &__members {
    display: flex;
    flex-wrap: wrap;
  }

  &__member {
    flex: 0 0 auto;
    margin: 0 0.3rem 0.3rem 0;
  }
}
</style>
