<template>
  <div>
    <div class="comment">
      <div class="comment__header">
        <oy-avatar size="32" :data="user"></oy-avatar>
        <div class="pl-2">
          <div v-if="user" class="comment__username">
            {{ user.surname }} {{ user.name }}
          </div>
          <div class="comment__created-at">
            {{ $utils.formatDate(comment.created_at) }}
          </div>
        </div>
      </div>
      <div v-if="!comment.json_message">
        <div
          v-if="!edit_comment_visible"
          class="comment__body"
          v-html="parseComment(comment.message)"
        ></div>
      </div>
      <div v-else class="p-2">
        <div v-for="(p, i) in comment.json_message.content" :key="i">
          <span v-for="(item, i) in p.content" :key="i">
            &nbsp;
            <span
              v-if="item.type === 'text'"
              :style="{
                fontWeight: item.marks
                  ? item.marks.find(el => el.type === 'bold')
                    ? 'bold'
                    : 'normal'
                  : 'normal',
                fontStyle: item.marks
                  ? item.marks.find(el => el.type === 'italic')
                    ? 'italic'
                    : 'normal'
                  : 'normal',
                textDecoration: item.marks
                  ? item.marks.find(el => el.type === 'underline')
                    ? 'underline'
                    : 'none'
                  : 'none'
              }"
            >
              <span
                :style="{ wordWrap: 'break-word' }"
                v-html="item.text !== null ? renderLinks(item.text) : ' '"
              ></span>
            </span>
            <span v-if="item.type === 'mention'"
              >&nbsp;
              <img
                :src="avatarPath(getUser(item.attrs.id))"
                width="22"
                height="22"
                style="border-radius: 100%"
              />
              <span class="ml-1" style="font-weight: 600">{{
                `${getUser(item.attrs.id).surname} ${
                  getUser(item.attrs.id).name
                }`
              }}</span
              >&nbsp;
            </span>
          </span>
        </div>
      </div>
      <div
        v-if="!answer_visible && !edit_comment_visible && userIsMember"
        class="comment__footer"
      >
        <a href="#" @click.prevent="answer_visible = true">Ответить</a>
        <a
          v-if="isInitiator"
          href="#"
          class="ml-2"
          @click.prevent="edit_comment_visible = true"
          >Изменить</a
        >
      </div>
      <editor
        v-if="answer_visible"
        :parent_id="parent_id"
        @close="answer_visible = false"
      ></editor>
      <editor
        v-if="edit_comment_visible"
        :comment="comment"
        @close="edit_comment_visible = false"
      ></editor>
    </div>
    <div v-if="comment.children.length > 0" class="comment__children">
      <slot></slot>
    </div>
  </div>
</template>

<script>
import editor from "../comments/editor";
import anchorme from "anchorme";

export default {
  props: {
    comment: {
      type: Object
    }
  },
  data: () => ({
    answer_visible: false,
    edit_comment_visible: false
  }),
  computed: {
    parent_id: function() {
      return this.comment.parent_id ? this.comment.parent_id : this.comment._id;
    },
    user: function() {
      return this.$store.getters["users/instance"](this.comment.user_id);
    },
    isInitiator: function() {
      return this.comment.user_id === this.authUser._id;
    },
    authUser: function() {
      return this.$store.getters["user/instance"];
    },
    userIsMember: function() {
      return this.card?.members?.find(el => el === this.authUser._id);
    },
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    }
  },
  methods: {
    renderLinks(text) {
      return anchorme(text);
    },
    parseComment(message) {
      let tempDiv = document.createElement("div");
      tempDiv.innerHTML = message;

      if (tempDiv.querySelectorAll("span.mention").length > 0) {
        tempDiv.querySelectorAll("span.mention").forEach(el => {
          el.innerHTML = "";
          el.classList.remove("mention");
          el.classList.add("comment__mention");
          const user_id = el?.dataset?.mentionId;
          if (user_id) {
            const user = this.getUser(user_id);
            const fio = `<span class="ml-1" style="font-weight: 600">&nbsp;${user.surname} ${user.name}</span>`;
            const avatar = `<img src="${this.avatarPath(
              user
            )}" width="22" height="22" style="border-radius: 100%" />`;
            el.innerHTML = `<span class="ml-1">${avatar + fio}</span>`;
          }
        });
      }

      return tempDiv.outerHTML;
    },
    getUser(id) {
      return this.$store.getters["users/instance"](id);
    },
    avatarPath: function(user) {
      return `${this.$api.url}/${this.$api.avatars_path}/${user.alias}/thumbnails/w_32_${user.avatar_name}`;
    }
  },
  components: {
    editor
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.comment {
  font-size: 13px;
  margin-bottom: 0.5rem;
  border: 1px solid $oc-gray-2;

  &__header,
  &__body,
  &__footer {
    padding: 0.5rem 0.7rem;
  }

  &__header {
    border-bottom: 1px solid $oc-gray-2;
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

  &__mention {
    &--avatar {
      width: 22px;
      height: 22px;
      border-radius: 100%;
      background-position: center;
      background-size: cover;
    }
  }
}
</style>
