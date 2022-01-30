import oyInput from "./components/oy-input.vue";
import oyButton from "./components/oy-button.vue";
import oyCircleButton from "./components/oy-circle-button.vue";
import oyActionButton from "./components/oy-action-button.vue";
import oyAvatar from "./components/oy-avatar.vue";
import oyFeatherIcon from "./components/oy-feather-icon";
import oyCheckbox from "./components/oy-checkbox.vue";
import oyRadioButton from "./components/oy-radio-button.vue";
import oySelect from "./components/oy-select.vue";
import oyDropdownMenu from "./components/oy-dropdown-menu.vue";
import oyDropdownMenuItem from "./components/oy-dropdown-menu-item.vue";
import oyBadge from "./components/oy-badge.vue";
import oyDatesRange from "./components/oy-dates-range.vue";
import oyLabel from "./components/oy-lable.vue";

import vSelect from "vue-select";

import oc from "open-color/open-color.json";
import Vue from "vue";

import "vue-select/dist/vue-select.css";

export const $modal = new Vue({
  name: "$modal",
  methods: {
    open(options) {
      this.$emit("open", options);
    },
    close(options) {
      this.$emit("close", options);
    }
  }
});

Vue.prototype.$api = {
  url: process.env.VUE_APP_API_URL,
  avatars_path: "storage/avatars",
  attachments_path: "storage/attachments"
};

export default {
  install: Vue => {
    Vue.prototype.$oc = oc;
    Vue.prototype.$modal = $modal;

    Vue.component("oy-input", oyInput);
    Vue.component("oy-button", oyButton);
    Vue.component("oy-circle-button", oyCircleButton);
    Vue.component("oy-action-button", oyActionButton);
    Vue.component("oy-avatar", oyAvatar);
    Vue.component("oy-feather-icon", oyFeatherIcon);
    Vue.component("oy-checkbox", oyCheckbox);
    Vue.component("oy-radio-button", oyRadioButton);
    Vue.component("oy-select", oySelect);
    Vue.component("oy-dropdown-menu", oyDropdownMenu);
    Vue.component("oy-dropdown-menu-item", oyDropdownMenuItem);
    Vue.component("oy-search-select", vSelect);
    Vue.component("oy-badge", oyBadge);
    Vue.component("oy-dates-range", oyDatesRange);
    Vue.component("oy-label", oyLabel);

    Vue.mixin({
      methods: {
        systemScopeHas(name) {
          return (
            this.$store.getters["user/permissions/systemScope"]?.find(
              el => el === name
            ) !== undefined
          );
        },
        boardScopeHas(board_id, name) {
          return (
            this.$store.getters["user/permissions/boardScope"](board_id)?.find(
              el => el === name
            ) !== undefined
          );
        },
        columnScopeHas(board_id, column_id, name) {
          return (
            this.$store.getters["user/permissions/columnScope"]({
              board_id,
              column_id
            })?.find(el => el === name) !== undefined
          );
        }
      }
    });
  }
};
