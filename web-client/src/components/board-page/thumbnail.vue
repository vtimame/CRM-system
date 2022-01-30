<template>
  <div
    class="thumbnail"
    :class="{
      'thumbnail--has-events': notifications.length > 0,
      'thumbnail--delete': card.deleteAction === true
    }"
    @click="openCard(card._id)"
  >
    <div v-if="notifications.length > 0" class="thumbnail__indicators">
      <oy-feather-icon type="bell" size="14" />
    </div>
    <div
      v-if="cover"
      class="thumbnail__cover"
      :style="{ backgroundImage: `url(${getCoverPath(cover)})` }"
    ></div>
    <div v-if="title" class="thumbnail__title">
      <div>
        {{ title
        }}<span
          v-if="card.deleteAction === true"
          :style="{ color: $oc.red[5] }"
        >
          [УДАЛИТЬ]</span
        >
      </div>

      <div
        :style="{ fontSize: '12px', fontWeight: 500 }"
        class="d-flex flex-wrap"
        v-if="card.labels && card.labels.length > 0"
      >
        <oy-label
          v-for="(label, i) in card.labels"
          :key="i"
          :name="label.name"
          :color="label.color"
          :small="true"
          class="mr-1 mb-1"
        />
      </div>

      <div class="d-flex align-items-center">
        <div v-if="attachments" class="mr-2 d-flex align-items-center">
          <oy-feather-icon type="paperclip" size="14" />
          <span :style="{ fontWeight: 500 }"
            >&nbsp;{{ attachments.length }}</span
          >
        </div>
        <div v-if="comments_count" class="mr-2 d-flex align-items-center">
          <oy-feather-icon type="message-circle" size="14" />
          <span :style="{ fontWeight: 500 }">&nbsp;{{ comments_count }}</span>
        </div>
        <div
          v-if="waiting_calls && waiting_calls.length > 0"
          class="mr-2 d-flex align-items-center"
        >
          <oy-feather-icon type="phone" size="14" />
          <span :style="{ fontWeight: 500 }"
            >&nbsp;{{ waiting_calls.length }}</span
          >
        </div>
        <div
          v-if="waiting_meetings && waiting_meetings.length > 0"
          class="mr-2 d-flex align-items-center"
        >
          <oy-feather-icon type="users" size="14" />
          <span :style="{ fontWeight: 500 }"
            >&nbsp;{{ waiting_meetings.length }}</span
          >
        </div>
      </div>
    </div>

    <div v-if="address" class="thumbnail__divider">
      <div class="thumbnail__label">Адрес</div>
    </div>

    <div v-if="address" class="thumbnail__address">
      <span>{{ address.street }}, д. {{ address.street_num }}</span>
    </div>

    <div v-if="contacts && contacts.length > 0" class="thumbnail__divider">
      <div class="thumbnail__label">Контакты</div>
    </div>

    <div v-if="contacts && contacts.length > 0" class="thumbnail__contacts">
      <div v-for="contact in contacts" :key="contact._id">
        {{ contact.surname }} {{ contact.name }} {{ contact.patronymic }}
      </div>
    </div>

    <div v-if="card.members" class="thumbnail__divider">
      <div class="thumbnail__label">Участники</div>
    </div>

    <div v-if="card.members" class="thumbnail__members">
      <div v-for="(member_id, i) in members" :key="i">
        <oy-avatar
          v-if="member_instance(member_id)"
          class="thumbnail__member"
          :data="member_instance(member_id)"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    card: {
      type: Object,
      required: true
    }
  },
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    users: function() {
      return this.$store.getters["users/list"];
    },
    roles: function() {
      return this.$store.getters["roles/list"];
    },
    userPermissions: function() {
      return this.$store.getters["user/permissions/columnPermissions"]({
        board_id: this.card.board_id,
        column_id: this.card.column_id
      });
    },
    notifications: function() {
      return this.$store.getters["user/notifications/notRead"]?.filter(
        el => el.event?.card_id === this.card._id
      );
    },
    cover: function() {
      return this.card?.cover;
    },
    title: function() {
      return this.card?.title;
    },
    address: function() {
      return this.card?.address;
    },
    contacts: function() {
      return this.card?.contacts;
    },
    attachments: function() {
      return this.card?.attachments;
    },
    comments_count: function() {
      return this.card?.comments_count;
    },
    waiting_calls: function() {
      if (!this.userPermissions.view_calls) return [];
      if (!this.userPermissions.view_calls) return [];
      const roles = this.userPermissions.view_calls.role_list
        ? this.userPermissions.view_calls.role_list
        : [];
      const initiators = this.users
        .filter(el => roles.find(r => r === el.role_id))
        .map(u => u._id);

      switch (this.userPermissions.view_calls.value) {
        case "all":
          return this.card?.waiting_calls;
        case "initiator":
          return this.card?.waiting_calls.filter(
            el => el.user_id === this.user._id
          );
        case "role_list":
          return this.card?.waiting_calls.filter(el =>
            initiators.find(i => i === el.user_id)
          );
        default:
          return this.card?.waiting_calls;
      }
    },
    waiting_meetings: function() {
      if (!this.userPermissions.view_meetings) return [];
      const roles = this.userPermissions.view_meetings.role_list
        ? this.userPermissions.view_meetings.role_list
        : [];
      const initiators = this.users
        .filter(el => roles.find(r => r === el.role_id))
        .map(u => u._id);

      switch (this.userPermissions.view_meetings.value) {
        case "all":
          return this.card?.waiting_meetings;
        case "initiator":
          return this.card?.waiting_meetings.filter(
            el => el.user_id === this.user._id
          );
        case "role_list":
          return this.card?.waiting_meetings.filter(el =>
            initiators.find(i => i === el.user_id)
          );
        default:
          return this.card?.waiting_meetings;
      }
    },
    members: function() {
      if (!this.card.members) return [];
      return this.card.members.filter(el => el !== undefined);
    }
  },
  methods: {
    async openCard(card_id) {
      if (!this.$route.query.card_id || this.$route.query.card_id !== card_id) {
        await this.$router.push({ query: { card_id } });
      }

      this.$modal.open({
        name: "opened-card",
        closable: false,
        width: "850px",
        position: "top",
        card_id
      });
    },
    getCoverPath(cover) {
      return `${this.$api.url}/${this.$api.attachments_path}/${this.card._id}/thumbnails/w_300_${cover.name}`;
    },
    member_instance(member_id) {
      return this.$store.getters["users/instance"](member_id);
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.thumbnail {
  background-color: white;
  margin-bottom: 0.5rem;
  cursor: pointer;
  font-size: 13px;
  border-radius: 3px;
  border: 1px solid $oc-gray-3;
  position: relative;

  &__indicators {
    position: absolute;
    top: 0;
    right: 4px;
    color: $oc-red-5;
  }

  &--has-events {
    border-color: $oc-red-3;
  }

  &--delete {
    border-color: $oc-orange-3;
    background-color: $oc-orange-0;
  }

  &__title {
    font-weight: 700;
    font-size: 14px;
    padding: 0.3rem 0.5rem;
  }

  &__address {
    padding: 0.3rem 0.5rem;
  }

  &__contacts {
    color: $oc-green-8;
    font-weight: 600;
    padding: 0.3rem 0.5rem;
  }

  &__members {
    display: flex;
    padding: 0.5rem 0.5rem 0.1rem 0.5rem;
    flex-wrap: wrap;
  }

  &__member {
    margin-right: 0.3rem;
    margin-bottom: 0.3rem;
  }

  &__divider {
    height: 1px;
    margin: 0.4rem 0 0.3rem 0;
    background-color: $oc-gray-3;
    position: relative;
  }

  &__label {
    position: absolute;
    font-size: 11px;
    background-color: $oc-gray-3;
    padding: 0.1rem 0.5rem;
    border-radius: 3px;
    top: -10px;
    left: 0.5rem;
  }

  &__cover {
    height: 150px;
    background-size: cover;
    background-repeat: no-repeat;
    border-bottom: 1px solid $oc-gray-3;
  }
}
</style>
