<template>
  <div class="pbx-page h-100">
    <div class="container-fluid py-2">
      <div class="pbx-page__title">Голосовые приложения</div>
      <div class="pbx-page__subtitle">Отдел корпоративных продаж</div>
      <div class="row">
        <div class="col-lg-3 col-md-6">
          <oy-input
            label="Номер очереди"
            :value="managers_queue_number"
            @change="onChange('managers_queue_number', $event)"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import store from "../../store";
export default {
  async beforeRouteEnter(to, from, next) {
    await store.dispatch("app/pbx/loadSettings");
    next();
  },
  computed: {
    settings: function() {
      return this.$store.getters["app/pbx/settings"];
    },
    managers_queue_number: function() {
      return this.settings?.managers_queue_number;
    }
  },
  methods: {
    async onChange(name, value) {
      await this.$store.dispatch("app/pbx/updateSettings", { [name]: value });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.pbx-page {
  background-color: white;

  &__title {
    color: $oc-gray-8;
    font-size: 1.2rem;
    line-height: 1.2rem;
    font-weight: 600;
  }

  &__subtitle {
    font-weight: 600;
  }
}
</style>
