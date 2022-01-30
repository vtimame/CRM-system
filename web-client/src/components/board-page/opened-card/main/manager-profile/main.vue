<template>
  <profile-section>
    <div class="d-flex">
      <oy-checkbox
        :value="new_room"
        :disabled="disabled"
        @input="$emit('change', { value: $event, key: 'new_room' })"
        >Новое помещение</oy-checkbox
      >
      <oy-checkbox
        class="ml-3"
        :disabled="disabled"
        :value="room_plan"
        @input="$emit('change', { value: $event, key: 'room_plan' })"
        >План помещения</oy-checkbox
      >
    </div>
    <div class="row no-gutters mt-2">
      <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
        <div>Куда звонить</div>
        <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
          <oy-input
            :disabled="disabled"
            :value="when_contact"
            @change="$emit('change', { value: $event, key: 'when_contact' })"
          />
        </div>
      </div>
      <div class="d-md-flex col-md-6 align-items-center pl-0 pl-md-2">
        <div>Источник</div>
        <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
          <oy-search-select
            :searchable="false"
            class="search-source-select"
            :options="source_options"
            label="label"
            :value="sourceValue"
            :clearable="false"
            @input="onSelectSource"
          />
        </div>
      </div>
    </div>
  </profile-section>
</template>

<script>
import profileSection from "./section.vue";

export default {
  props: [
    "new_room",
    "room_plan",
    "when_contact",
    "learn_about_us",
    "disabled"
  ],
  data: () => ({
    source_options: [
      { value: "site", label: "Сайт" },
      { value: "2gis", label: "2гис" },
      { value: "agent", label: "Агент" },
      { value: "landlord", label: "Наш БЦ" },
      { value: "manager", label: "Менеджер" },
      { value: "yandex", label: "Яндекс" },
      { value: "google", label: "Google" },
      { value: "social_networks", label: "Соцсети" },
      { value: "acquaintance", label: "Совет знакомого" },
      { value: "aggregator", label: "Агрегатор" },
      { value: "stand", label: "Стойка" },
      { value: "signboard", label: "Вывеска" },
      { value: "leaflet", label: "Листовка" },
      { value: "newsletter", label: "Рассылка" },
      { value: "car", label: "Машина" },
      { value: "devices", label: "Оборудование" }
    ]
  }),
  computed: {
    sourceValue: function() {
      return (
        this.source_options.find(el => el.value === this.learn_about_us) ||
        "Не указано"
      );
    }
  },
  methods: {
    onSelectSource(source) {
      this.$emit("change", { value: source.value, key: "learn_about_us" });
    }
  },
  components: {
    profileSection
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.search-source-select {
  background-color: white;
  @include scrollbars(4px, $oc-gray-4, $oc-gray-2);
}
</style>
