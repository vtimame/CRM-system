<template>
  <component
    :is="!parent_id && !comment ? 'card-section' : 'div'"
    :title="componentTitle"
  >
    <div class="comment-editor" :class="{ answer: parent_id || comment }">
      <mentions
        :visible="mentions_show"
        :members="filteredMembers"
        @onMention="onMention"
      ></mentions>
      <div v-if="action !== 'comment'" class="comment-editor__datepicker">
        <date-picker
          v-model="action_date"
          :style="{ width: '100%' }"
          placeholder="Выберите дату события"
          type="datetime"
          format="DD.MM.YYYY H:mm"
          :disabled-date="notBeforeDate"
          :disabled-time="notBeforeTime"
        ></date-picker>
      </div>
      <editor-menu-bubble
        :editor="editor"
        v-slot="{ commands, isActive, menu }"
      >
        <div
          class="comment-editor__menu-bubble"
          :class="{ 'comment-editor__menu-bubble--active': menu.isActive }"
          :style="{ left: `${menu.left}px`, bottom: `${menu.bottom}px` }"
        >
          <div
            class="menu-bubble__button"
            :class="{ 'menu-bubble__button--active': isActive.bold() }"
            @click="commands.bold"
          >
            <oy-feather-icon type="bold" size="14"></oy-feather-icon>
          </div>
          <div
            class="menu-bubble__button"
            :class="{ 'menu-bubble__button--active': isActive.italic() }"
            @click="commands.italic"
          >
            <oy-feather-icon type="italic" size="14"></oy-feather-icon>
          </div>
          <div
            class="menu-bubble__button"
            :class="{ 'menu-bubble__button--active': isActive.underline() }"
            @click="commands.underline"
          >
            <oy-feather-icon type="underline" size="14"></oy-feather-icon>
          </div>
        </div>
      </editor-menu-bubble>
      <editor-content
        class="comment-editor__content"
        :editor="editor"
      ></editor-content>
      <div class="comment-editor__actions">
        <oy-button
          type="success"
          :disabled="submitButtonDisabledState"
          @click="onSubmit"
          >{{ parent_id ? "Ответить" : "Отправить" }}</oy-button
        >
        <div v-if="parent_id || comment" class="ml-3">
          <a href="#" @click.prevent="$emit('close')" class="text-danger"
            >Отмена</a
          >
        </div>
        <div
          v-if="
            (!parent_id &&
              columnScopeHas(card.board_id, card.column_id, 'add_calls')) ||
              columnScopeHas(card.board_id, card.column_id, 'add_meetings')
          "
          class="action-button ml-2"
          :class="{ 'action-button--selected': action === 'comment' }"
          @click="action = 'comment'"
        >
          <oy-feather-icon type="message-circle" size="16"></oy-feather-icon>
        </div>
        <div
          v-if="
            !parent_id &&
              columnScopeHas(card.board_id, card.column_id, 'add_calls') &&
              !scheduled.call
          "
          class="action-button ml-2"
          :class="{ 'action-button--selected': action === 'call' }"
          @click="action = 'call'"
        >
          <oy-feather-icon type="phone" size="16"></oy-feather-icon>
        </div>
        <div
          v-if="
            !parent_id &&
              columnScopeHas(card.board_id, card.column_id, 'add_meetings') &&
              !scheduled.meeting
          "
          class="action-button ml-2"
          :class="{ 'action-button--selected': action === 'meeting' }"
          @click="action = 'meeting'"
        >
          <oy-feather-icon type="users" size="16"></oy-feather-icon>
        </div>
        <div class="ml-3 d-flex align-items-center">
          <transition-group
            name="typing"
            tag="div"
            :style="{
              display: 'flex',
              alignItems: 'center',
              transition: '0.2s'
            }"
          >
            <div
              class="users_type__item"
              v-for="typer in users_type"
              :key="typer._id"
              :style="{ marginLeft: '-10px' }"
            >
              <oy-avatar
                :data="typer"
                size="26"
                :style="{ border: '2px solid white' }"
              />
            </div>
          </transition-group>
          <div
            v-if="users_type.length === 1"
            class="ml-1"
            :style="{ fontSize: '11px' }"
          >
            Печатает...
          </div>
          <div
            v-if="users_type.length > 1"
            class="ml-1"
            :style="{ fontSize: '11px' }"
          >
            Печатают...
          </div>
        </div>
      </div>
    </div>
  </component>
</template>

<script>
import _find from "lodash/find";
import { map, flatten, filter } from "lodash";
import { Editor, EditorContent, EditorMenuBubble } from "tiptap";
import { Bold, Italic, Underline, Mention } from "tiptap-extensions";
import cardSection from "../section.vue";
import DatePicker from "vue2-datepicker";
import mentions from "./mentions";
import moment from "moment";
import mentionService from "../../../../../services/mentionService";

export default {
  props: {
    parent_id: {
      type: String,
      default: null
    },
    comment: {
      type: Object,
      default: null
    },
    editMode: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    message: "",
    jsonMessage: null,
    editor: null,
    action: "comment",
    action_date: null,
    mentions_show: false,
    insertMention: () => {},
    suggestionRange: null,
    filteredMembers: [],
    users_type: []
  }),
  computed: {
    componentTitle: function() {
      if (this.parent_id) return null;
      switch (this.action) {
        case "call":
          return "Запланировать звонок";
        case "meeting":
          return "Запланировать встречу";
        default:
          return "Оставить комментарий";
      }
    },
    messageIsEmpty: function() {
      return this.message.replace(/(<([^>]+)>)/gi, "").length === 0;
    },
    submitButtonDisabledState: function() {
      if (this.action !== "comment") {
        return this.action_date === null || this.messageIsEmpty;
      }

      return this.messageIsEmpty;
    },
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    user: function() {
      return this.$store.getters["user/instance"];
    },
    users: function() {
      return this.$store.getters["users/list"];
    },
    members: function() {
      return this.users.filter(el => {
        return this.card.members.find(id => id === el._id);
      });
    },
    events: function() {
      return this.$store.getters["kanban/card/events/list"];
    },
    scheduled: function() {
      const call = _find(this.$store.getters["kanban/card/events/list"], {
        user_id: this.user._id,
        render_type: "call",
        status: "waiting"
      });
      const meeting = _find(this.$store.getters["kanban/card/events/list"], {
        user_id: this.user._id,
        render_type: "meeting",
        status: "waiting"
      });

      return { call, meeting };
    }
  },
  mounted() {
    if (this.comment) {
      this.message = this.comment.message;
      this.jsonMessage = this.comment.jsonMessage;
    }

    this.$echo
      .private(`card.${this.card._id}`)
      .listenForWhisper("typing", user => {
        if (!this.users_type.find(el => el._id === user._id)) {
          this.users_type.push(user);
          setTimeout(() => {
            const index = this.users_type.findIndex(el => el._id === user._id);
            this.users_type.splice(index, 1);
          }, 3000);
        }
      })
      .listenForWhisper("eventWasAdded", event => {
        if (!event.parent_id)
          this.$store.commit("kanban/card/events/pushEvent", event);
        else this.$store.commit("kanban/card/events/pushChildEvent", event);
      });

    this.editor = new Editor({
      extensions: [
        new Bold(),
        new Italic(),
        new Underline(),
        new Mention({
          items: this.members,
          onEnter: this.mentionsController,
          onExit: () => {
            this.mentions_show = false;
          },
          onFilter: this.filterMembers
        })
      ],
      autoFocus: true,
      content: this.message,
      onUpdate: event => {
        this.message = event.getHTML();
        this.jsonMessage = event.getJSON();
      },
      editorProps: {
        handleKeyDown: this.onKeyDown
      }
    });
  },
  methods: {
    notBeforeDate(date) {
      return date < new Date().setHours(0, 0, 0, 0);
    },
    notBeforeTime(date) {
      return date < new Date().setMinutes(20);
    },
    mentionsController({ items, query, range, command, virtualNode }) {
      this.filteredMembers = items;
      this.suggestionRange = range;
      this.insertMention = command;
      this.mentions_show = true;
    },
    filterMembers(items, query) {
      if (!query) {
        this.filteredMembers = items;
        return items;
      }
      const re = new RegExp(query, "ig");
      this.filteredMembers = items.filter(el => {
        if (query.length > 0) return el.alias.match(re);
        return el;
      });
    },
    onMention(member) {
      this.mentions_show = false;
      this.insertMention({
        range: this.suggestionRange,
        attrs: {
          id: member._id,
          label: member.alias
        }
      });
      this.editor.focus();
    },
    async getMentions() {
      const content = flatten(this.jsonMessage.content.map(el => el.content));
      return content
        .filter(el => el?.type === "mention")
        .map(el => el.attrs.id);
    },
    async onSubmit() {
      const mentions = await this.getMentions();
      if (this.action === "comment") await this.storeComment();
      else await this.storeCommand();
      await mentionService.sendMentinos({
        ids: mentions,
        card_id: this.$route.query.card_id
      });
    },
    async storeComment() {
      const eventData = {
        message: this.message,
        json_message: this.jsonMessage,
        card_id: this.card._id,
        parent_id: this.parent_id,
        render_type: "comment"
      };

      if (this.comment) {
        eventData._id = this.comment._id;
        eventData.children = this.comment.children;
        eventData.user = this.comment.user;
        eventData.user_id = this.comment.user_id;
      }
      const event = await this.$store.dispatch(
        `kanban/card/events/${this.comment ? "updateEvent" : "storeEvent"}`,
        eventData
      );

      if (!this.comment) {
        this.$echo
          .private(`card.${this.card._id}`)
          .whisper("eventWasAdded", event.data);
      }

      this.clearEditor();
      if (this.parent_id || this.comment) this.$emit("close");
    },
    async storeCommand() {
      const event = await this.$store.dispatch(
        "kanban/card/events/storeEvent",
        {
          card_id: this.card._id,
          comment_message: this.message,
          json_message: this.jsonMessage,
          command_type: this.action,
          render_type: this.action,
          status: "waiting",
          event_dt: moment(this.action_date).format("YYYY-MM-DD HH:mm:ss")
        }
      );
      this.$echo
        .private(`card.${this.card._id}`)
        .whisper("eventWasAdded", event.data);
      this.clearEditor();
    },
    clearEditor() {
      this.action_date = null;
      this.action = "comment";
      this.message = "";
      this.jsonMessage = null;
      this.editor.clearContent();
    },
    onKeyDown() {
      this.$echo.private(`card.${this.card._id}`).whisper("typing", this.user);
    }
  },
  components: {
    cardSection,
    EditorContent,
    EditorMenuBubble,
    DatePicker,
    mentions
  },
  beforeDestroy() {
    this.editor.destroy();
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.comment-editor {
  cursor: text;
  border: 1px solid $oc-gray-3;

  &__datepicker {
    .mx-input {
      border-radius: 0;
      border-top: none;
      border-left: none;
      border-right: none;
      border-bottom-color: $oc-gray-3;
    }
  }

  &__content {
    padding: 0.5rem 1rem;

    .ProseMirror {
      font-size: 13px;
      min-height: 100px;

      &-focused {
        outline: none;
      }
    }
  }

  &__menu-bubble {
    visibility: hidden;
    position: absolute;
    display: flex;
    background-color: $oc-gray-9;
    border-radius: 3px;
    margin-bottom: 0.5rem;
    transform: translateX(-50%);
    opacity: 0;
    transition: opacity 0.2s, visibility 0.2s;

    &--active {
      opacity: 1;
      visibility: visible;
    }

    .menu-bubble__button {
      cursor: pointer;
      padding: 0.3rem 0.5rem;
      color: white;
      transition: 0.2s;

      &:hover {
        background-color: $oc-gray-8;
      }

      &--active {
        background-color: $oc-gray-8;
      }
    }
  }

  &__actions {
    display: flex;
    align-items: center;
    border-top: 1px solid $oc-gray-3;
    padding: 0.5rem;

    .action-button {
      width: 28px;
      height: 28px;
      display: flex;
      justify-content: center;
      align-items: center;
      color: $oc-gray-6;
      cursor: pointer;
      transition: 0.2s;

      &:hover {
        color: $oc-gray-9;
      }

      &--selected {
        color: $oc-gray-9;
      }
    }
  }
}

.users_type {
  display: flex;
  align-items: center;

  &__item {
  }
}

.answer {
  border: none;
  border-top: 1px solid $oc-gray-3;
}
</style>
