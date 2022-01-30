<template>
  <div class="card-client">
    <div>
      <div>ID в CRM</div>
      <oy-input
        :disabled="disabled"
        :value="old_crm_id"
        @change="onChange('old_crm_id', $event)"
      />
    </div>
    <div class="mt-3">
      <div>Линк</div>
      <oy-input
        :disabled="disabled"
        :value="link"
        @change="onChange('link', $event)"
      />
    </div>
    <div class="mt-3">
      <div>Новый адрес</div>
      <oy-input
        :disabled="disabled"
        :value="new_address"
        @change="onChange('new_address', $event)"
      />
    </div>
    <div class="my-3">
      <div>Услуги</div>
      <oy-input
        :disabled="disabled"
        :value="services"
        @change="onChange('services', $event)"
      />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    client: {
      type: Object
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    old_crm_id: function() {
      return this.client?.old_crm_id;
    },
    link: function() {
      return this.client?.link;
    },
    new_address: function() {
      return this.client?.new_address;
    },
    services: function() {
      return this.client?.services;
    }
  },
  methods: {
    onChange(key, value) {
      this.$emit("change", Object.assign({}, this.client, { [key]: value }));
    }
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-client {
  background-color: $oc-gray-1;
  border-radius: 3px;
  color: $oc-gray-8;
  margin-top: 0.3rem;
  padding: 0.5rem 1rem;
}
</style>
