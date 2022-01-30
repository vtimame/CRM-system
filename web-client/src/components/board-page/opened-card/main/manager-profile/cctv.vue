<template>
  <profile-section>
    <div class="cctv">
      <div class="row d-flex align-items-center">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>Видеонаблюдение</span>
          <oy-radio-button
            :disabled="disabled"
            :value="CCTV"
            @change="$emit('change', { value: $event, key: 'CCTV' })"
          ></oy-radio-button>
        </div>
        <div v-if="CCTV === true" class="col-6 d-flex">
          <oy-checkbox
            :disabled="disabled"
            :value="cctv_pro"
            @input="$emit('change', { value: $event, key: 'cctv_pro' })"
            >PRO</oy-checkbox
          >
          <oy-checkbox
            :disabled="disabled"
            class="ml-3"
            :value="cctv_sound"
            @input="$emit('change', { value: $event, key: 'cctv_sound' })"
            >Звук</oy-checkbox
          >
        </div>
      </div>

      <div v-if="CCTV === true" class="row mt-2">
        <div class="d-md-flex col-6 align-items-center mb-2 mb-md-0">
          <div>Кол-во камер</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              v-only-numbers
              :value="cctv_cameras_count"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'cctv_cameras_count'
                })
              "
            />
          </div>
        </div>

        <div class="d-md-flex col-6 align-items-center mb-2 mb-md-0">
          <div>Где делаем</div>
          <div :style="{ flex: '1 1 0%' }" class="pl-0 pl-md-2">
            <oy-input
              :disabled="disabled"
              :value="CCTV_location"
              @change="
                $emit('change', {
                  value: $event,
                  key: 'CCTV_location'
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
    "CCTV",
    "CCTV_location",
    "cctv_cameras_count",
    "cctv_pro",
    "cctv_sound",
    "disabled"
  ],
  components: {
    profileSection
  }
};
</script>
