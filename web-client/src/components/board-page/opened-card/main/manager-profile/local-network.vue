<template>
  <profile-section>
    <div class="local-network">
      <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>Локальная сеть</span>
          <oy-radio-button
            :value="local_network"
            :disabled="disabled"
            @change="$emit('change', { value: $event, key: 'local_network' })"
          ></oy-radio-button>
        </div>
      </div>

      <div class="row mt-2">
        <div
          v-if="local_network === true"
          class="col-6 d-flex align-items-center justify-content-between"
        >
          <span>Тестировали</span>
          <oy-radio-button
            :value="local_network_arranges"
            :disabled="disabled"
            @change="
              $emit('change', { value: $event, key: 'local_network_arranges' })
            "
          ></oy-radio-button>
        </div>
        <div
          v-else
          class="col-6 d-flex align-items-center justify-content-between"
        >
          <span>Делаем ЛС</span>
          <oy-radio-button
            :value="local_network_pull"
            :disabled="disabled"
            @change="
              $emit('change', { value: $event, key: 'local_network_pull' })
            "
          ></oy-radio-button>
        </div>
        <div
          v-if="local_network === true || local_network_pull === true"
          class="d-md-flex col-md-6 align-items-center mb-2 mb-md-0"
        >
          <div>Количество РМ</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="local_network_pm_count"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'local_network_pm_count'
                })
              "
            />
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
    "local_network",
    "local_network_arranges",
    "local_network_pm_count",
    "local_network_pull",
    "disabled"
  ],
  components: {
    profileSection
  }
};
</script>
