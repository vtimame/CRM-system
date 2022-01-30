<template>
  <profile-section>
    <div class="iptv">
      <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>IPTV</span>
          <oy-radio-button
            :disabled="disabled"
            :value="iptv"
            @change="$emit('change', { value: $event, key: 'iptv' })"
          ></oy-radio-button>
        </div>
        <div
          v-if="iptv === true"
          class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0"
        >
          <div>Тип</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-select
              :disabled="disabled"
              :value="iptv_type"
              disabled-option="Выберите тип"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'iptv_type'
                })
              "
            >
              <option
                v-for="option in iptv_type_options"
                :key="option.value"
                :value="option.value"
                :selected="option.value === iptv_type"
              >
                {{ option.label }}
              </option>
            </oy-select>
          </div>
        </div>
      </div>

      <div v-if="iptv === true" class="row mt-2 d-flex align-items-center">
        <div class="d-md-flex col-6 align-items-center mb-2 mb-md-0">
          <div>Кол-во экранов</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="iptv_screens_count"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'iptv_screens_count'
                })
              "
            />
          </div>
        </div>
        <div>
          <oy-checkbox
            :disabled="disabled"
            :value="iptv_box"
            @input="
              $emit('change', {
                value: $event,
                key: 'iptv_box'
              })
            "
            >Приставка</oy-checkbox
          >
        </div>
      </div>
    </div>
  </profile-section>
</template>

<script>
import profileSection from "./section.vue";

export default {
  props: ["iptv", "iptv_box", "iptv_screens_count", "iptv_type", "disabled"],
  data: () => ({
    iptv_type_options: [
      { value: "public", label: "Публичный" },
      { value: "office", label: "Офис" },
      { value: "hotel", label: "Отель" }
    ]
  }),
  components: {
    profileSection
  }
};
</script>
