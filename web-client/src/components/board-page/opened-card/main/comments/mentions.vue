<template>
  <div class="mentions">
    <transition name="mentions-list">
      <div v-if="visible" class="mentions__list" ref="list">
        <div
          class="mentions__item"
          :class="{
            'mentions__item--selected': i === navigatedUserIndex
          }"
          v-for="(member, i) in members"
          @mouseover="onMouseover(i)"
          @click="enterHandler"
          :key="member._id"
        >
          <oy-avatar :data="member"></oy-avatar>
          <div class="pl-2">
            <div class="mentions__item-name">
              {{ member.surname }} {{ member.name }}
            </div>
            <div class="mentions__item-alias">{{ member.alias }}</div>
          </div>
        </div>
      </div>
    </transition>
  </div>
</template>

<script>
export default {
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    members: {
      type: Array,
      default: () => []
    }
  },
  data: () => ({
    navigatedUserIndex: 0
  }),
  beforeMount() {
    this.navigatedUserIndex = 0;
    window.addEventListener("keydown", this.keydownController, true);
  },
  beforeDestroy() {
    window.removeEventListener("keydown", this.keydownController, true);
  },
  methods: {
    keydownController(event) {
      if (this.visible === true) {
        if (event.key === "ArrowUp") {
          event.preventDefault();
          this.upHandler();
          return true;
        }
        if (event.key === "ArrowDown") {
          event.preventDefault();
          this.downHandler();
          return true;
        }
        if (event.key === "Enter") {
          event.preventDefault();
          this.enterHandler();
          return true;
        }
      }
      return false;
    },
    upHandler() {
      if (this.navigatedUserIndex > 0) {
        this.navigatedUserIndex -= 1;
      }
    },
    downHandler() {
      if (this.navigatedUserIndex < this.members.length - 1) {
        this.navigatedUserIndex += 1;
      }
    },
    onMouseover(index) {
      this.navigatedUserIndex = index;
    },
    enterHandler() {
      this.$emit("onMention", this.members[this.navigatedUserIndex]);
    }
  },
  watch: {
    members: {
      handler(members, oldMembers) {
        this.navigatedUserIndex = 0;
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "src/assets/sass/mixins";
@import "~open-color/open-color";

.mentions {
  position: relative;

  &__list {
    max-height: 250px;
    overflow-y: auto;
    position: absolute;
    background-color: white;
    bottom: 0;
    width: 100%;
    border: 1px solid $oc-gray-3;
    border-radius: 3px 3px 0 0;
    @include scrollbars(4px, $oc-gray-4, $oc-gray-2);
  }

  &__item {
    display: flex;
    align-items: center;
    padding: 0.3rem 0.5rem;
    transition: 0.2s;
    border-radius: 3px;
    cursor: pointer;

    &-name {
      font-weight: 600;
      font-size: 13px;
      line-height: 13px;
    }

    &-alias {
      font-size: 12px;
      line-height: 13px;
    }

    &--selected {
      color: white;
      background-color: $oc-blue-5;
    }
  }
}
</style>
