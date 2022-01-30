<template>
  <div class="command" :class="[`command--${command.status}`]">
    <div class="command__header">
      <oy-avatar size="32" :data="user"></oy-avatar>
      <div class="pl-2">
        <div class="command__username">
          {{ user.surname }} {{ user.name }}
          <span :style="{ fontWeight: 500 }">
            запланировал {{ commandType }}
            {{ $utils.formatDate(command.event_dt) }}</span
          >
        </div>
        <div class="command__created-at">
          {{ $utils.formatDate(command.created_at) }}
        </div>
      </div>
    </div>
    <div class="command__body" v-html="command.comment_message"></div>
    <div v-if="command.report_message" class="command__body">
      <div :style="{ fontWeight: 600 }">Отчет</div>
      <div v-html="command.report_message"></div>
    </div>
    <div v-if="command.status === 'waiting'" class="command__footer">
      <a
        href="#"
        @click.prevent="
          $modal.open({
            name: 'close-command',
            width: '550px',
            command: command,
            callback: onCloseCommand
          })
        "
        >Завершить</a
      >
    </div>
  </div>
</template>

<script>
export default {
  props: {
    command: {
      type: Object
    }
  },
  computed: {
    commandType: function() {
      switch (this.command.command_type) {
        case "call":
          return "звонок";
        case "meeting":
          return "встречу";
        default:
          return "";
      }
    },
    user: function() {
      return this.$store.getters["users/instance"](this.command.user_id);
    }
  },
  methods: {
    async onCloseCommand(data) {
      await this.$store.dispatch(
        "kanban/card/events/updateEvent",
        Object.assign({}, this.command, data)
      );
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.command {
  font-size: 13px;
  margin-bottom: 0.5rem;
  border: 1px solid $oc-gray-2;

  &--waiting {
    border-left: 3px solid $oc-yellow-8;
  }

  &--reject {
    border-left: 3px solid $oc-red-8;
  }

  &--resolve {
    border-left: 3px solid $oc-green-8;
  }

  &__header,
  &__body,
  &__footer {
    padding: 0.5rem 0.7rem;
  }

  &__body {
    border-top: 1px solid $oc-gray-2;
  }

  &__header {
    display: flex;
    align-items: center;
    padding: 0.5rem;
  }

  &__footer {
    border-top: 1px solid $oc-gray-2;
  }

  &__username {
    font-weight: 600;
    line-height: 13px;
  }

  &__created-at {
    font-size: 11px;
    line-height: 13px;
  }

  &__children {
    margin-left: 1rem;
    padding-left: 1rem;
    border-left: 1px dashed $oc-blue-2;
    transition: 0.2s;

    &:hover {
      border-left-color: $oc-blue-5;
    }
  }
}
</style>
