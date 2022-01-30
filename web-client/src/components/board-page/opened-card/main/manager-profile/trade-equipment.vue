<template>
  <profile-section>
    <div class="trade-equipment">
      <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span :style="{ lineHeight: '13px' }">Торговое оборудование</span>
          <oy-radio-button
            :disabled="disabled"
            :value="trade_equipment"
            @change="$emit('change', { value: $event, key: 'trade_equipment' })"
          ></oy-radio-button>
        </div>
      </div>

      <div v-if="trade_equipment === true" class="row mt-2">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span :style="{ lineHeight: '13px' }">Терминалы POS</span>
          <oy-radio-button
            :disabled="disabled"
            :value="trade_equipment_pos_need"
            @change="
              $emit('change', {
                value: $event,
                key: 'trade_equipment_pos_need'
              })
            "
          ></oy-radio-button>
        </div>
        <div v-if="trade_equipment_pos_need === true" class="col-6">
          <div class="row">
            <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
              <div>Тип</div>
              <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
                <oy-select
                  :disabled="disabled"
                  :value="trade_equipment_pos_type"
                  disabled-option="Выберите тип"
                  @change="
                    $emit('change', {
                      value: $event,
                      key: 'trade_equipment_pos_type'
                    })
                  "
                >
                  <option
                    v-for="option in trade_equipment_type_options"
                    :key="option.value"
                    :value="option.value"
                    :selected="option.value === trade_equipment_pos_type"
                  >
                    {{ option.label }}
                  </option>
                </oy-select>
              </div>
            </div>
            <div
              v-if="trade_equipment_pos_type === 'ls'"
              class="d-md-flex col-6 align-items-center mb-2 mb-md-0"
            >
              <div>Кол-во</div>
              <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
                <oy-input
                  :disabled="disabled"
                  v-only-numbers
                  :value="trade_equipment_pos_count"
                  @change="
                    $emit('change', {
                      value: $event,
                      key: 'trade_equipment_pos_count'
                    })
                  "
                />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="trade_equipment === true" class="row mt-2">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span :style="{ lineHeight: '13px' }">Онлайн кассы</span>
          <oy-radio-button
            :disabled="disabled"
            :value="trade_equipment_cashbox_need"
            @change="
              $emit('change', {
                value: $event,
                key: 'trade_equipment_cashbox_need'
              })
            "
          ></oy-radio-button>
        </div>
        <div v-if="trade_equipment_cashbox_need === true" class="col-6">
          <div class="row">
            <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
              <div>Тип</div>
              <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
                <oy-select
                  :disabled="disabled"
                  :value="trade_equipment_cashbox_type"
                  disabled-option="Выберите тип"
                  @change="
                    $emit('change', {
                      value: $event,
                      key: 'trade_equipment_cashbox_type'
                    })
                  "
                >
                  <option
                    v-for="option in trade_equipment_type_options"
                    :key="option.value"
                    :value="option.value"
                    :selected="option.value === trade_equipment_cashbox_type"
                  >
                    {{ option.label }}
                  </option>
                </oy-select>
              </div>
            </div>
            <div
              v-if="trade_equipment_cashbox_type === 'ls'"
              class="d-md-flex col-6 align-items-center mb-2 mb-md-0"
            >
              <div>Кол-во</div>
              <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
                <oy-input
                  :disabled="disabled"
                  v-only-numbers
                  :value="trade_equipment_cashbox_count"
                  @change="
                    $emit('change', {
                      value: $event,
                      key: 'trade_equipment_cashbox_count'
                    })
                  "
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </profile-section>
</template>

<script>
import profileSection from "./section.vue";

export default {
  props: [
    "trade_equipment",
    "trade_equipment_cashbox_count",
    "trade_equipment_cashbox_need",
    "trade_equipment_cashbox_type",
    "trade_equipment_pos_count",
    "trade_equipment_pos_need",
    "trade_equipment_pos_type",
    "disabled"
  ],
  data: () => ({
    trade_equipment_type_options: [
      { value: "sim", label: "SIM" },
      { value: "wifi", label: "WIFI" },
      { value: "ls", label: "ЛС" }
    ]
  }),
  components: {
    profileSection
  }
};
</script>
