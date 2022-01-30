<template>
  <div class="card-actions">
    <div class="card-actions__header mb-2">
      <div class="card-actions__title">
        <div>{{ title }}</div>
      </div>
      <div>
        <oy-feather-icon
          type="message-circle"
          size="18"
          class="cursor-pointer card-actions__button"
          :class="{ 'card-actions__button--active': actions.comments.visible }"
          @click="actions.comments.visible = !actions.comments.visible"
        ></oy-feather-icon>

        <oy-feather-icon
          type="list"
          size="18"
          class="cursor-pointer ml-2 card-actions__button"
          :class="{ 'card-actions__button--active': actions.events.visible }"
          @click="actions.events.visible = !actions.events.visible"
        ></oy-feather-icon>

        <oy-feather-icon
          type="phone"
          size="18"
          class="cursor-pointer ml-2 card-actions__button"
          :class="{ 'card-actions__button--active': actions.calls.visible }"
          @click="actions.calls.visible = !actions.calls.visible"
        ></oy-feather-icon>

        <oy-feather-icon
          type="users"
          size="18"
          class="cursor-pointer ml-2 card-actions__button"
          :class="{ 'card-actions__button--active': actions.meetings.visible }"
          @click="actions.meetings.visible = !actions.meetings.visible"
        ></oy-feather-icon>
      </div>
    </div>
    <div v-if="active_events.length > 0" class="card-actions__body">
      <div v-for="(event, i) in active_events" :key="i">
        <comment v-if="event.render_type === 'comment'" :comment="event">
          <comment
            v-for="children in event.children"
            :key="children._id"
            :comment="children"
          ></comment>
        </comment>
        <user-command
          v-if="event.render_type === 'call' || event.render_type === 'meeting'"
          :command="event"
        ></user-command>
        <event
          v-if="event.render_type === 'event' && actionMustRender(event)"
          :event="event"
        ></event>
      </div>
    </div>
    <!--    <div v-if="active_actions.length === 0">-->
    <!--      Все события скрыты-->
    <!--    </div>-->
    <!--    <div v-if="active_actions.length > 0 && all_actions.length === 0">-->
    <!--      Здесь пока нет ни одного действия-->
    <!--    </div>-->
  </div>
</template>

<script>
import _orderBy from "lodash/orderBy";
import comment from "./actions/comment.vue";
import userCommand from "./actions/command.vue";
import event from "./actions/event.vue";

export default {
  data: () => ({
    actions: {
      comments: {
        visible: true,
        title: "Комментарии"
      },
      events: {
        visible: false,
        title: "События"
      },
      calls: {
        visible: true,
        title: "Звонки"
      },
      meetings: {
        visible: true,
        title: "Встречи"
      }
    }
  }),
  computed: {
    title: function() {
      return "Комментарии";
    },
    events: function() {
      return this.$store.getters["kanban/card/events/list"];
    },
    active_events: function() {
      let events = [];

      if (this.actions.comments.visible) {
        const comments = this.events.filter(el => el.render_type === "comment");
        events = events.concat(comments);
      }

      if (this.actions.calls.visible) {
        const calls = this.events.filter(el => el.render_type === "call");
        events = events.concat(calls);
      }

      if (this.actions.meetings.visible) {
        const meetings = this.events.filter(el => el.render_type === "meeting");
        events = events.concat(meetings);
      }

      if (this.actions.events.visible) {
        const cardEvents = this.events.filter(el => el.render_type === "event");
        events = events.concat(cardEvents);
      }

      return _orderBy(events, ["created_at"], ["desc"]);
    }
  },
  methods: {
    actionMustRender(event) {
      const excepted_types = [
        "userMustCall",
        "userMustMeeting",
        "remindCardActivity",
        "reportExpiredEvents"
      ];
      const findInExcept = excepted_types.find(el => el === event.type);
      return event._id && !findInExcept;
    }
  },
  components: {
    comment,
    userCommand,
    event
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.card-actions {
  &__header {
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  &__title {
    font-weight: 600;
    font-size: 1rem;
  }

  &__button {
    stroke: $oc-gray-6;
    transition: 0.2s;

    &:hover {
      stroke: $oc-gray-8;
    }

    &--active {
      stroke: $oc-gray-9;
    }
  }
}
</style>
