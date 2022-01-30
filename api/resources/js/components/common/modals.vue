<template>
  <div>
    <transition-group name="fade">
      <component
        v-for="item in modals"
        :key="item.name"
        :is="item.name"
        :options="item"
      />
    </transition-group>
  </div>
</template>
<script>
import openedCard from './modals/opened-card.vue';
import newCard from './modals/new-card.vue';

import _reject from 'lodash/reject';

export default {
  data: () => ({
    modals: [],
  }),
  created() {
    this.$modal.$on('open', (options) => {
      const modal = this.modals.find((o) => o.name === options.name);
      if (!modal) this.modals.push(options);
    });

    this.$modal.$on('close', (name) => {
      this.modals = _reject(this.modals, (o) => o.name === name);
    });
  },
  components: {
    openedCard,
    newCard,
  },
};
</script>
