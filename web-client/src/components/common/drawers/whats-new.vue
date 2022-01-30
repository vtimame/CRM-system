<template>
  <div class="drawer">
    <transition name="fade">
      <div
        @click="$emit('close-drawer')"
        v-if="opened"
        class="drawer__wrapper"
      ></div>
    </transition>
    <div class="drawer__drawer" :class="{ 'drawer__drawer--opened': opened }">
      <div class="drawer__header">
        <div class="drawer__header-title">Что нового</div>
      </div>
      <div class="drawer__body">
        <el-timeline :reverse="false">
          <el-timeline-item
            v-for="(activity, index) in activities"
            :key="index"
            :timestamp="activity.timestamp"
          >
            {{ activity.content }}
          </el-timeline-item>
        </el-timeline>
      </div>
    </div>
  </div>
</template>

<script>
import { Timeline, TimelineItem } from "element-ui";
import "element-ui/lib/theme-chalk/timeline.css";

export default {
  props: {
    opened: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    activities: [
      {
        content: "Event start",
        timestamp: "2018-04-15"
      },
      {
        content: "Approved",
        timestamp: "2018-04-13"
      },
      {
        content: "Success",
        timestamp: "2018-04-11"
      }
    ]
  }),
  components: {
    "el-timeline": Timeline,
    "el-timeline-item": TimelineItem
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.drawer {
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
    width: 600px;
    top: 0;
    right: 0;
    margin-right: -600px;
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
    border-bottom: 1px solid $oc-gray-3;
    display: flex;
    align-items: center;
    justify-content: space-between;

    &-title {
      font-weight: 600;
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
    padding: 0.3rem 1rem;
  }
}
</style>
