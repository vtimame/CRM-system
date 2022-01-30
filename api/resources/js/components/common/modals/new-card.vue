<template>
  <wrapper :options="options">New card</wrapper>
</template>

<script>
import modal from './modal';

export default {
  mixins: [modal],
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.opened-card {
  color: $oc-gray-7;
  position: relative;

  &__main {
    // flex: 1;
  }

  &__aside {
    // width: 273px;
  }
}
</style>
