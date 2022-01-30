<template>
  <div class="card-address">
    <div class="row no-gutters mb-3">
      <div class="col-md-10 pr-2">
        <oy-input
          label="Улица"
          :value="address.street"
          :disabled="disabled"
          :error="getError('street')"
          @change="onChange($event, 'street')"
        />
      </div>
      <div class="col-md-2">
        <oy-input
          label="Номер дома"
          v-only-numbers
          :value="address.street_num"
          :disabled="disabled"
          :error="getError('street_num')"
          @change="onChange($event, 'street_num')"
        />
      </div>
    </div>
    <div class="row no-gutters">
      <div class="col-md-2 pr-2">
        <oy-input
          label="Корпус"
          :value="address.building"
          :disabled="disabled"
          @change="onChange($event, 'building')"
        />
      </div>
      <div class="col-md-2 pr-2">
        <oy-input
          label="Литера"
          :value="address.litera"
          :disabled="disabled"
          @change="onChange($event, 'litera')"
        />
      </div>
      <div class="col-md-2 pr-2">
        <oy-input
          label="Этаж"
          v-only-numbers
          :value="address.floor"
          :disabled="disabled"
          @change="onChange($event, 'floor')"
        />
      </div>
      <div class="col-md-2 pr-2">
        <oy-input
          label="Офис"
          :value="address.office"
          :disabled="disabled"
          @change="onChange($event, 'office')"
        />
      </div>
      <div class="col-md-4">
        <div>Тип помещения</div>
        <oy-select
          :value="address.room_type"
          :disabled="disabled"
          @change="onChange($event, 'room_type')"
        >
          <option
            v-for="option in room_types"
            :key="option.value"
            :value="option.value"
            :selected="option.value === address.room_type"
          >
            {{ option.label }}
          </option>
        </oy-select>
      </div>
    </div>
  </div>
</template>

<script>
import { required, numeric } from "vuelidate/lib/validators";

export default {
  props: {
    address: {
      type: Object
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data: () => ({
    room_types: [
      { value: "office", label: "Офис" },
      { value: "cafe", label: "Кафе" },
      { value: "restaurant", label: "Ресторан" },
      { value: "hotel", label: "Отель" },
      { value: "shop", label: "Магазин" },
      { value: "other", label: "Иное" }
    ]
  }),
  validations: {
    values: {
      street: { required },
      street_num: { required, numeric }
    }
  },
  methods: {
    onChange(value, key) {
      // this.values[key] = value;
      // this.$v.$touch();
      // this.$emit("onErrorChange", !this.$v.$error);
      // if (!this.$v.$error) this.$emit("change", this.values);
      this.$emit("change", { [`address.${key}`]: value });
    },
    getError(name) {
      if (this.$v.$dirty) {
        const target = this.$v.values[name];
        if (target.required === false) return "Заполните это поле";
        if (target.numeric === false) return "numeric";
        return "";
      }
    }
  },
  watch: {
    address: function(newVal, oldVal) {
      // this.title = newVal;
    }
  }
};
</script>
