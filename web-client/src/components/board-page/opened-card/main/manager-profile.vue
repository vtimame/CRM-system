<template>
  <div class="card-manager-profile">
    <main-section
      :disabled="disabled"
      :new_room="profile.new_room"
      :room_plan="profile.room_plan"
      :when_contact="profile.when_contact"
      :learn_about_us="profile.learn_about_us"
      @change="onChange"
    ></main-section>

    <internet
      :disabled="disabled"
      :internet="profile.internet"
      :internet_speed="profile.internet_speed"
      @change="onChange"
    ></internet>

    <local-network
      :disabled="disabled"
      :profile="profile"
      :local_network="profile.local_network"
      :local_network_arranges="profile.local_network_arranges"
      :local_network_pm_count="profile.local_network_pm_count"
      :local_network_pull="profile.local_network_pull"
      @change="onChange"
    ></local-network>

    <telephony
      :disabled="disabled"
      :telephony="profile.telephony"
      :our-virtual-p-b-x_apparatus="profile.ourVirtualPBX_apparatus"
      :our-virtual-p-b-x_apparatus_count="profile.ourVirtualPBX_apparatus_count"
      :our-virtual-p-b-x_apparatus_type="profile.ourVirtualPBX_apparatus_type"
      :our-virtual-p-b-x_lines="profile.ourVirtualPBX_lines"
      :our-virtual-p-b-x_numbers="profile.ourVirtualPBX_numbers"
      :own-p-b-x_lines="profile.ownPBX_lines"
      :own-p-b-x_model="profile.ownPBX_model"
      :own-p-b-x_numbers="profile.ownPBX_numbers"
      :own-virtual-p-b-x_connections="profile.ownVirtualPBX_connections"
      :own-virtual-p-b-x_numbers="profile.ownVirtualPBX_numbers"
      :telephony_type="profile.telephony_type"
      @change="onChange"
    ></telephony>

    <wifi
      :disabled="disabled"
      :wifi="profile.wifi"
      :wifi_2ssid="profile.wifi_2ssid"
      :wifi_access="profile.wifi_access"
      :wifi_devices="profile.wifi_devices"
      :wifi_need_auth="profile.wifi_need_auth"
      :wifi_oyspot="profile.wifi_oyspot"
      :wifi_radar="profile.wifi_radar"
      :wifi_vendor="profile.wifi_vendor"
      @change="onChange"
    ></wifi>

    <trade-equipment
      :disabled="disabled"
      :trade_equipment="profile.trade_equipment"
      :trade_equipment_cashbox_count="profile.trade_equipment_cashbox_count"
      :trade_equipment_cashbox_need="profile.trade_equipment_cashbox_need"
      :trade_equipment_cashbox_type="profile.trade_equipment_cashbox_type"
      :trade_equipment_pos_count="profile.trade_equipment_pos_count"
      :trade_equipment_pos_need="profile.trade_equipment_pos_need"
      :trade_equipment_pos_type="profile.trade_equipment_pos_type"
      @change="onChange"
    ></trade-equipment>

    <cctv
      :disabled="disabled"
      :c-c-t-v="profile.CCTV"
      :c-c-t-v_location="profile.CCTV_location"
      :cctv_cameras_count="profile.cctv_cameras_count"
      :cctv_pro="profile.cctv_pro"
      :cctv_sound="profile.cctv_sound"
      @change="onChange"
    ></cctv>

    <outsourcing
      :disabled="disabled"
      :it_outsourcing="profile.it_outsourcing"
      @change="onChange"
    ></outsourcing>

    <iptv
      :disabled="disabled"
      :iptv="profile.iptv"
      :iptv_box="profile.iptv_box"
      :iptv_screens_count="profile.iptv_screens_count"
      :iptv_type="profile.iptv_type"
      @change="onChange"
    ></iptv>
  </div>
</template>

<script>
import mainSection from "./manager-profile/main.vue";
import internet from "./manager-profile/internet.vue";
import localNetwork from "./manager-profile/local-network.vue";
import telephony from "./manager-profile/telephony.vue";
import wifi from "./manager-profile/wifi.vue";
import tradeEquipment from "./manager-profile/trade-equipment.vue";
import cctv from "./manager-profile/cctv.vue";
import outsourcing from "./manager-profile/outsourcing.vue";
import iptv from "./manager-profile/iptv.vue";

export default {
  props: {
    profile: {
      // type: [Object, Array, null]
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    onChange({ value, key }) {
      this.$emit("change", Object.assign({}, this.profile, { [key]: value }));
    }
  },
  components: {
    mainSection,
    internet,
    localNetwork,
    telephony,
    wifi,
    tradeEquipment,
    cctv,
    outsourcing,
    iptv
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-manager-profile {
  background-color: $oc-gray-1;
  border-radius: 3px;
  color: $oc-gray-8;
  margin-top: 0.3rem;
}
</style>
