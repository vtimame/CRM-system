<template>
  <profile-section>
    <div class="telephony">
      <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>Телефония</span>
          <oy-radio-button
            :disabled="disabled"
            :value="telephony"
            @change="$emit('change', { value: $event, key: 'telephony' })"
          ></oy-radio-button>
        </div>
        <div
          v-if="telephony === true"
          class="col-6 d-flex align-items-center justify-content-between"
        >
          <oy-select
            :disabled="disabled"
            :value="telephony_type"
            disabled-option="Выберите тип АТС"
            @change="$emit('change', { value: $event, key: 'telephony_type' })"
          >
            <option
              v-for="option in telephony_type_options"
              :key="option.value"
              :value="option.value"
              :selected="option.value === telephony_type"
            >
              {{ option.label }}
            </option>
          </oy-select>
        </div>
      </div>

      <div v-if="telephony_type === 'ownPBX'" class="row mt-2">
        <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
          <div>Модель</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              :value="ownPBX_model"
              @change="$emit('change', { value: $event, key: 'ownPBX_model' })"
            />
          </div>
        </div>
      </div>

      <div v-if="telephony_type === 'ownPBX'" class="row mt-2">
        <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
          <div>Кол-во линий</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="ownPBX_lines"
              @change="$emit('change', { value: $event, key: 'ownPBX_lines' })"
            />
          </div>
        </div>
        <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
          <div>Кол-во номеров</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="ownPBX_numbers"
              @change="
                $emit('change', { value: $event, key: 'ownPBX_numbers' })
              "
            />
          </div>
        </div>
      </div>

      <div v-if="telephony_type === 'ownVirtualPBX'" class="row mt-2">
        <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
          <div>Кол-во номеров</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="ownVirtualPBX_numbers"
              @change="
                $emit('change', { value: $event, key: 'ownVirtualPBX_numbers' })
              "
            />
          </div>
        </div>

        <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
          <div>Кол-во соединений</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="ownVirtualPBX_connections"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'ownVirtualPBX_connections'
                })
              "
            />
          </div>
        </div>
      </div>

      <div v-if="telephony_type === 'ourVirtualPBX'" class="row mt-2">
        <div class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0">
          <div>Кол-во номеров</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="ourVirtualPBX_numbers"
              @change="
                $emit('change', { value: $event, key: 'ourVirtualPBX_numbers' })
              "
            />
          </div>
        </div>

        <div
          v-if="ourVirtualPBX_apparatus === false"
          class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0"
        >
          <div>Кол-во линий</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="ourVirtualPBX_lines"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'ourVirtualPBX_lines'
                })
              "
            />
          </div>
        </div>
      </div>

      <div v-if="telephony_type === 'ourVirtualPBX'" class="row mt-2">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>Аппараты наши</span>
          <oy-radio-button
            :disabled="disabled"
            :value="ourVirtualPBX_apparatus"
            @change="
              $emit('change', { value: $event, key: 'ourVirtualPBX_apparatus' })
            "
          ></oy-radio-button>
        </div>

        <div
          v-if="ourVirtualPBX_apparatus === true"
          class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0"
        >
          <div>Количество</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="ourVirtualPBX_lines"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'ourVirtualPBX_lines'
                })
              "
            />
          </div>
        </div>
        <div
          v-if="ourVirtualPBX_apparatus === false"
          class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0"
        >
          <div>Тип</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-select
              :disabled="disabled"
              :value="ourVirtualPBX_apparatus_type"
              disabled-option="Выберите тип аппаратов"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'ourVirtualPBX_apparatus_type'
                })
              "
            >
              <option
                v-for="option in ourVirtualPBX_apparatus_type_options"
                :key="option.value"
                :value="option.value"
                :selected="option.value === ourVirtualPBX_apparatus_type"
              >
                {{ option.label }}
              </option>
            </oy-select>
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
    "telephony",
    "telephony_type",
    "ourVirtualPBX_apparatus",
    "ourVirtualPBX_apparatus_count",
    "ourVirtualPBX_apparatus_type",
    "ourVirtualPBX_lines",
    "ourVirtualPBX_numbers",
    "ownPBX_lines",
    "ownPBX_model",
    "ownPBX_numbers",
    "ownVirtualPBX_connections",
    "ownVirtualPBX_numbers",
    "disabled"
  ],
  data: () => ({
    telephony_type_options: [
      { value: "ownPBX", label: "Своя железная АТС" },
      { value: "ownVirtualPBX", label: "Своя виртуальная АТС" },
      { value: "ourVirtualPBX", label: "Наша виртуальная АТС" }
    ],
    ourVirtualPBX_apparatus_type_options: [
      { value: "analog", label: "Аналоговые" },
      { value: "sip", label: "SIP" },
      { value: "unknown", label: "Не знаю" }
    ]
  }),
  components: {
    profileSection
  }
};
</script>
