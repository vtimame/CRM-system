<template>
  <div class="dashboard-page">
    <!--    <grid-layout-->
    <!--      class="dashboard-page__widgets-layout h-100"-->
    <!--      :layout.sync="testLayout"-->
    <!--      :col-num="12"-->
    <!--      :row-height="30"-->
    <!--      :is-draggable="true"-->
    <!--      :is-resizable="true"-->
    <!--      :is-mirrored="false"-->
    <!--      :vertical-compact="true"-->
    <!--      :margin="[10, 10]"-->
    <!--      :use-css-transforms="true"-->
    <!--      :responsive="true"-->
    <!--    >-->
    <!--      <grid-item-->
    <!--        class="dashboard-page__widgets-item"-->
    <!--        v-for="item in testLayout"-->
    <!--        :x="item.x"-->
    <!--        :y="item.y"-->
    <!--        :w="item.w"-->
    <!--        :h="item.h"-->
    <!--        :i="item.i"-->
    <!--        :key="item.i"-->
    <!--      >-->
    <!--        <component :is="item.component" />-->
    <!--      </grid-item>-->
    <!--    </grid-layout>-->
  </div>
</template>

<script>
import VueGridLayout from "vue-grid-layout";
import test from "../components/dashboard/widgets/test.vue";

export default {
  data: () => ({
    testLayout: [{ x: 0, y: 0, w: 4, h: 6, i: "1", component: "test" }]
  }),
  components: {
    // "grid-layout": VueGridLayout.GridLayout,
    // "grid-item": VueGridLayout.GridItem,
    // test
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.dashboard-page {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 12px;
  overflow-y: auto;
  @include scrollbars(4px, $oc-gray-5, $oc-gray-3);

  &__widgets-layout {
    background-color: white;
  }

  &__widgets-item {
    border: 1px solid $oc-gray-3;
  }
}
</style>
