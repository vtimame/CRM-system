<template>
  <wrapper :options="options">
    <div class="opened-card">
      <card-main class="opened-card__main"></card-main>
      <card-aside class="opened-card__aside"></card-aside>
    </div>
  </wrapper>
</template>

<script>
import modal from './modal';
import { Row, Col } from 'ant-design-vue';
import cardMain from '../../board/card-main.vue';
import cardAside from '../../board/card-aside.vue';

export default {
  mixins: [modal],
  components: {
    cardMain,
    cardAside,
    'a-row': Row,
    'a-col': Col,
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.opened-card {
  color: $oc-gray-7;
  display: flex;

  &__main {
    flex: 1;
  }

  &__aside {
    width: 270px;
    background-color: $oc-gray-0;
  }
}
</style>
