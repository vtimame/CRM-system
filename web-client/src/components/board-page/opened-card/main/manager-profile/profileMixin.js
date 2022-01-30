export default {
  // mounted() {
  //   if (this.managerProfile !== null) {
  //     this.profile = this.managerProfile;
  //   }
  // },
  // data: () => ({
  //   profile: {
  //     new_room: false,
  //     room_plan: false,
  //     outsiders: "",
  //     when_contact: "",
  //     learn_about_us: "",
  //     internet: undefined,
  //     internet_speed: "",
  //     local_network: undefined,
  //     local_network_pull: undefined,
  //     local_network_pm_count: "",
  //     local_network_arranges: undefined,
  //     telephony: undefined,
  //     telephony_type: "",
  //     ownPBX_model: "",
  //     ownPBX_lines: "",
  //     ownPBX_numbers: "",
  //     ownVirtualPBX_numbers: "",
  //     ownVirtualPBX_connections: "",
  //     ourVirtualPBX_lines: "",
  //     ourVirtualPBX_numbers: "",
  //     ourVirtualPBX_apparatus: undefined,
  //     ourVirtualPBX_apparatus_type: "",
  //     ourVirtualPBX_apparatus_count: "",
  //     wifi: undefined,
  //     wifi_devices: undefined,
  //     wifi_2ssid: false,
  //     wifi_need_auth: false,
  //     wifi_access: false,
  //     wifi_oyspot: false,
  //     CCTV: undefined,
  //     CCTV_location: "",
  //     trade_equipment_pos_count: "",
  //     trade_equipment_pos_need: undefined,
  //     trade_equipment_pos_type: "",
  //     trade_equipment_cashbox_count: "",
  //     trade_equipment_cashbox_need: undefined,
  //     trade_equipment_cashbox_type: "",
  //     trade_equipment: undefined,
  //     cctv_cameras_count: "",
  //     cctv_pro: false,
  //     cctv_sound: false,
  //     wifi_radar: false,
  //     it_outsourcing: undefined,
  //     iptv: undefined,
  //     iptv_type: "",
  //     iptv_screens_count: "",
  //     iptv_box: false,
  //     wifi_vendor: ""
  //   }
  // }),
  methods: {
    onChange({ value, key }) {
      this.$emit("change", { [`manager_profile.${key}`]: value });
    }
  }
};
