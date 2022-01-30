<template>
  <profile-section>
    <div class="wifi">
      <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>WI-FI сеть</span>
          <oy-radio-button
            :disabled="disabled"
            :value="wifi"
            @change="$emit('change', { value: $event, key: 'wifi' })"
          ></oy-radio-button>
        </div>
        <div
          v-if="wifi === true"
          class="col-6 d-flex align-items-center justify-content-between"
        >
          <span>Оборудование свое</span>
          <oy-radio-button
            :disabled="disabled"
            :value="wifi_devices"
            @change="$emit('change', { value: $event, key: 'wifi_devices' })"
          ></oy-radio-button>
        </div>
      </div>

      <div v-if="wifi_devices === true" class="row mt-2">
        <div class="col-12 d-flex align-items-center justify-content-between">
          <oy-select
            :disabled="disabled"
            :value="wifi_vendor"
            disabled-option="Выберите производителя"
            @change="$emit('change', { value: $event, key: 'wifi_vendor' })"
          >
            <option
              v-for="option in wifi_vendor_options"
              :key="option.value"
              :value="option.value"
              :selected="option.value === wifi_vendor"
            >
              {{ option.label }}
            </option>
          </oy-select>
        </div>
      </div>

      <div v-if="showCheckboxes || wifi_devices === false" class="d-flex mt-2">
        <oy-checkbox
          :disabled="disabled"
          v-if="wifi_devices === false"
          :value="wifi_2ssid"
          class="mr-2"
          @input="$emit('change', { value: $event, key: 'wifi_2ssid' })"
          >2SSID</oy-checkbox
        >
        <oy-checkbox
          :disabled="disabled"
          :value="wifi_need_auth"
          @input="$emit('change', { value: $event, key: 'wifi_need_auth' })"
          >Авторизация</oy-checkbox
        >
        <oy-checkbox
          :disabled="disabled"
          v-if="wifi_need_auth === true"
          class="ml-3"
          :value="wifi_oyspot"
          @input="$emit('change', { value: $event, key: 'wifi_oyspot' })"
          >OySpot</oy-checkbox
        >
        <oy-checkbox
          :disabled="disabled"
          v-if="wifi_oyspot === true"
          class="ml-3"
          :value="wifi_radar"
          @input="$emit('change', { value: $event, key: 'wifi_radar' })"
          >Радар</oy-checkbox
        >
      </div>
    </div>
  </profile-section>
</template>

<script>
import profileSection from "./section.vue";

export default {
  props: [
    "wifi",
    "wifi_2ssid",
    "wifi_access",
    "wifi_devices",
    "wifi_need_auth",
    "wifi_oyspot",
    "wifi_radar",
    "wifi_vendor",
    "disabled"
  ],
  data: () => ({
    wifi_vendor_options: [
      { value: "Asus", label: "Asus" },
      { value: "Tp-Link", label: "Tp-Link" },
      { value: "Buffalo", label: "Buffalo" },
      { value: "Huawei", label: "Huawei" },
      { value: "Zyxel", label: "Zyxel" },
      { value: "D-Link", label: "D-Link" },
      { value: "Ruckus", label: "Ruckus" },
      { value: "Mikrotik", label: "Mikrotik" },
      { value: "Unifi", label: "Unifi" },
      { value: "undefined", label: "Неизвестный" }
    ]
  }),
  computed: {
    showCheckboxes: function() {
      const vendors = ["Ruckus", "Mikrotik", "Unifi"];
      return vendors.find(el => el === this.wifi_vendor) !== undefined;
    }
  },
  components: {
    profileSection
  }
};
</script>
