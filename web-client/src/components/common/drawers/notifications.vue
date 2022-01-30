<template>
  <div class="notifications">
    <transition name="fade">
      <div
        @click="$emit('close-notifications')"
        v-if="opened"
        class="notifications__wrapper"
      ></div>
    </transition>
    <div
      class="notifications__drawer"
      :class="{ 'notifications__drawer--opened': opened }"
    >
      <div
        class="notifications__header d-flex align-items-center"
        @click="user_menu_visible = !user_menu_visible"
        :style="{ cursor: 'pointer' }"
      >
        <div class="d-flex align-items-center">
          <oy-avatar :data="user" size="42" class="mr-2" />
          <div>
            <div :style="{ fontWeight: 600, lineHeight: '13px' }">
              {{ user.surname }} {{ user.name }}
            </div>
            <div :style="{ fontSize: '12px', lineHeight: '13px' }">
              {{ user.role.name }}
            </div>
          </div>
        </div>
        <oy-feather-icon
          :type="`chevron-${user_menu_visible ? 'up' : 'down'}`"
          size="18"
        />
      </div>
      <div v-if="user_menu_visible" class="user-menu">
        <div class="user-menu__action" @click="openDevicesModal">
          <span>Устройства</span>
        </div>
        <div class="user-menu__action" @click="openQrAuthModal">
          <span>Войти с помощью QR-кода</span>
        </div>
        <div class="user-menu__action" @click="logout">
          Выйти
        </div>
      </div>
      <div class="notifications__header">
        <div class="notifications__header-title">Уведомления</div>
        <oy-feather-icon
          v-if="selectedNotificationsList.length > 0"
          type="check-circle"
          size="16"
          class="read-icon"
          @click="onIconClick"
        />
      </div>
      <div class="d-flex">
        <div
          class="notifications__header-tab mx-2"
          @click="selectedNotifications = 'creator'"
          :class="{
            'notifications__header-tab--selected':
              selectedNotifications === 'creator'
          }"
        >
          Мои
        </div>
        <div
          class="notifications__header-tab mx-2"
          @click="selectedNotifications = 'personal'"
          :class="{
            'notifications__header-tab--selected':
              selectedNotifications === 'personal'
          }"
        >
          Личные
        </div>
        <div
          class="notifications__header-tab mx-2"
          @click="selectedNotifications = 'other'"
          :class="{
            'notifications__header-tab--selected':
              selectedNotifications === 'other'
          }"
        >
          Все
        </div>
      </div>
      <div
        v-if="selectedNotificationsList.length > 0"
        class="notifications__body"
        ref="notifications__body"
      >
        <div
          v-for="(notification, i) in selectedNotificationsList"
          :key="i"
          class="notification"
        >
          <component
            v-if="notification.event"
            :is="notification.event.type"
            :data="notification"
            @close-notifications="$emit('close-notifications')"
          />
        </div>
      </div>
      <div
        v-else
        class="notifications__body d-flex justify-content-center align-items-center"
        :style="{ fontWeight: 600 }"
      >
        Здесь пока нет уведомлений
      </div>
    </div>
  </div>
</template>

<script>
import cardCommentWasAdded from "./notifications/cardCommentWasAdded";
import cardAnswerWasAdded from "./notifications/cardAnswerWasAdded";
import cardMentionWasAdded from "./notifications/cardMentionWasAdded";
import cardWasMoved from "./notifications/cardWasMoved";
import cardMemberWasAdded from "./notifications/cardMemberWasAdded";
import cardContactWasAdded from "./notifications/cardContactWasAdded";
import userMustMeeting from "./notifications/userMustMeeting";
import userMustCall from "./notifications/userMustCall";
import remindCardActivity from "./notifications/remindCardActivity";
import reportExpiredEvents from "./notifications/reportExpiredEvents";
import newSiteTicket from "./notifications/newSiteTicket";
import newCreator from "./notifications/newCreator";
import reportManagerExpiredEvents from "./notifications/reportManagerExpiredEvents";
import _orderBy from "lodash/orderBy";
import _find from "lodash/find";
import _filter from "lodash/filter";

export default {
  props: {
    opened: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    user_menu_visible: false,
    selectedNotifications: "personal",
    incrementTimeout: false,
    showLimit: {
      personal: 15,
      creator: 15,
      other: 15
    },
    personalTypes: [
      "cardAnswerWasAdded",
      "cardMentionWasAdded",
      "reportExpiredEvents",
      "newSiteTicket"
    ]
  }),
  mounted() {
    this.$store.dispatch("user/notifications/loadNotifications");
    this.listenNotificationsChannel();
    window.addEventListener("wheel", this.listenScrollEvent, true);
  },
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    notifications: function() {
      return this.$store.getters["user/notifications/list"];
    },
    selectedNotificationsList: function() {
      switch (this.selectedNotifications) {
        default:
        case "personal":
          return this.personalNotifications;
        case "creator":
          return this.creatorNotifications;
        case "other":
          return this.otherNotifications;
      }
    },
    personalNotifications: function() {
      const list = _filter(this.notifications, el => {
        return _find(this.personalTypes, o => o === el.event.type);
      });

      return _orderBy(list, ["created_at"], ["desc"]).splice(
        0,
        this.showLimit.personal
      );
    },
    otherNotifications: function() {
      const list = _filter(this.notifications, el => {
        const isPersonal = _find(this.personalTypes, o => o === el.event.type);
        const card = this.$store.getters["kanban/cards/rawInstance"](
          el.event.card_id
        );
        return !isPersonal && card?.creator_id !== this.user._id;
      });

      return _orderBy(list, ["created_at"], ["desc"]).splice(
        0,
        this.showLimit.other
      );
    },
    creatorNotifications: function() {
      const list = _filter(this.notifications, el => {
        const isPersonal = _find(this.personalTypes, o => o === el.event.type);
        const card = this.$store.getters["kanban/cards/rawInstance"](
          el.event.card_id
        );
        return !isPersonal && card?.creator_id === this.user._id;
      });

      return _orderBy(list, ["created_at"], ["desc"]).splice(
        0,
        this.showLimit.creator
      );
    },
    new_notifications_length: function() {
      return this.$store.getters["user/notifications/notRead"].length;
    }
  },
  methods: {
    listenScrollEvent(event) {
      const container = this.$refs["notifications__body"];
      if (
        container &&
        container.scrollTop > 0 &&
        event.target.closest(".notifications__body") !== null
      ) {
        if (
          container.scrollHeight - container.scrollTop ===
          container.offsetHeight
        ) {
          this.incrementShowLimit();
        }
      }
    },
    incrementShowLimit() {
      if (!this.incrementTimeout) {
        this.incrementTimeout = true;
        this.showLimit[this.selectedNotifications] += 15;
        setTimeout(() => {
          this.incrementTimeout = false;
        }, 500);
      }
    },
    isCreator(card_id) {
      const card = this.$store.getters["kanban/cards/rawInstance"](card_id);
      return card?.creator_id === this.user._id;
    },
    async onIconClick() {
      if (this.new_notifications_length > 0) {
        await this.$store.dispatch("user/notifications/markAllAsRead");
      }
    },
    openDevicesModal() {
      this.$modal.open({
        name: "manage-tokens",
        width: "550px",
        position: "top"
      });
      this.visible = false;
    },
    openQrAuthModal() {
      this.$modal.open({
        name: "qr-auth",
        width: "450px",
        position: "top"
      });
      this.visible = false;
    },
    async logout() {
      await this.$store.dispatch("user/logout");
      //
    },
    async listenNotificationsChannel() {
      this.$echo
        .join(`notifications.${this.user._id}`)
        .listen("NotificationWasReceived", data => {
          if (data.notification.event.type === "newSiteTicket") {
            this.$store.dispatch("kanban/cards/loadRawCards").then(() => {
              this.$notification.send(data.notification.event);
              this.$store.commit(
                "user/notifications/unshiftNotification",
                data.notification
              );
            });
          } else {
            this.$notification.send(data.notification.event);
            this.$store.commit(
              "user/notifications/unshiftNotification",
              data.notification
            );
          }
        });

      this.$echo
        .join(`pbx.${this.user._id}`)
        .listen("CallWasReceived", notification => {
          if (this.$route.query.card_id === notification.data.card._id)
            return false;
          this.$modal.open({
            name: "pbx-card-notification",
            width: "450px",
            position: "top",
            card: notification.data.card,
            contact: notification.data.contact
          });
        });
    }
  },
  components: {
    cardCommentWasAdded,
    cardAnswerWasAdded,
    cardMentionWasAdded,
    cardWasMoved,
    cardMemberWasAdded,
    cardContactWasAdded,
    userMustMeeting,
    userMustCall,
    remindCardActivity,
    reportExpiredEvents,
    newSiteTicket,
    newCreator,
    reportManagerExpiredEvents
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.notifications {
  .user-menu {
    border-bottom: 1px solid $oc-gray-1;
    &__action {
      padding: 0.4rem 0.7rem;
      cursor: pointer;
      transition: 0.2s;
      font-size: 13px;

      &:hover {
        background-color: $oc-gray-1;
      }
    }
  }

  &__wrapper {
    position: fixed;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
    background-color: rgba(0, 0, 0, 0.3);
    z-index: 2;
    cursor: pointer;
  }

  &__drawer {
    position: fixed;
    width: 380px;
    top: 0;
    right: 0;
    margin-right: -380px;
    background-color: white;
    height: 100%;
    z-index: 3;
    border-left: 1px solid $oc-gray-3;
    display: flex;
    flex-direction: column;
    transition: 0.25s cubic-bezier(0.82, 0.085, 0.395, 0.895);

    &--opened {
      margin-right: 0 !important;
    }
  }

  &__header {
    padding: 0.5rem 1rem;
    color: $oc-gray-8;
    border-bottom: 1px solid $oc-gray-1;
    display: flex;
    align-items: center;
    justify-content: space-between;

    &-title {
      font-weight: 600;
    }

    &-tab {
      flex: 1;
      display: flex;
      justify-content: center;
      width: 100%;
      padding: 0.3rem 1rem;
      border-bottom: 2px solid transparent;
      transition: 0.25s ease-in-out;
      cursor: pointer;

      &:hover {
        border-color: $oc-blue-3;
      }

      &--selected {
        border-color: $oc-blue-5 !important;
      }
    }

    .read-icon {
      color: $oc-gray-6;
      transition: 0.2s ease-in-out;
      cursor: pointer;

      &:hover {
        color: $oc-gray-8;
      }
    }
  }

  &__body {
    flex: 1;
    overflow-y: auto;
    @include scrollbars(5px, $oc-gray-5, $oc-gray-3);
  }
}
</style>
