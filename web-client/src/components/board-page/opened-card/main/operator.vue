<template>
  <div class="card-operator">
    <div>
      <div>Контакт оператора</div>
      <oy-input
        :disabled="disabled"
        :value="fio"
        @change="onChange('fio', $event)"
      />
    </div>
    <div class="mt-3">
      <div>Телефон оператора</div>
      <oy-input
        :disabled="disabled"
        :value="phone"
        @change="onChange('phone', $event)"
      />
    </div>
    <div class="my-3">
      <div>Кем представляться</div>
      <oy-input
        :disabled="disabled"
        :value="pseudoname"
        @change="onChange('pseudoname', $event)"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    operator: {
      type: Object
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    fio: function() {
      return this.operator?.fio;
    },
    phone: function() {
      return this.operator?.phone;
    },
    pseudoname: function() {
      return this.operator?.pseudoname;
    }
  },

  methods: {
    onChange(key, value) {
      this.$emit("change", Object.assign({}, this.operator, { [key]: value }));
    }
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-operator {
  background-color: $oc-gray-1;
  border-radius: 3px;
  color: $oc-gray-8;
  margin-top: 0.3rem;
  padding: 0.5rem 1rem;
}
</style>
