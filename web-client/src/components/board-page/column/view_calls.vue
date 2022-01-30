<template>
  <div class="view-calls">
    <div class="row no-gutters d-flex align-items-center">
      <div class="col-6">Видимость звонков</div>
      <div class="col-6">
        <oy-select :value="value" @change="onChange">
          <option :selected="ruleValue === 'all'" value="all">Все</option>
          <option :selected="ruleValue === 'initiator'" value="initiator"
            >Собственные</option
          >
          <option :selected="ruleValue === 'role_list'" value="role_list"
            >Список ролей</option
          >
        </oy-select>
      </div>
    </div>
    <div v-if="value === 'role_list'" class="mt-2 mb-2">
      <oy-search-select
        :options="potencial_roles"
        label="name"
        value="Выберите роль"
        :clearable="false"
        @input="onRoleSelected"
      />
      <div v-if="selected_roles.length > 0" class="mt-2">
        <oy-action-button v-for="(id, i) in selected_roles" :key="id">
          <oy-feather-icon
            slot="postfix"
            type="x"
            size="14"
            @click="onRoleDelete(i)"
          />
          {{ $store.getters["roles/instance"](id).name }}
        </oy-action-button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    ruleValue: {
      type: String,
      default: ""
    },
    ruleSelectedRoles: {
      type: Array,
      default: () => []
    }
  },
  mounted() {
    this.value = this.ruleValue;
    this.selected_roles = this.ruleSelectedRoles;
  },
  data: () => ({
    value: "all",
    selected_roles: []
  }),
  computed: {
    roles: function() {
      return this.$store.getters["roles/list"];
    },
    potencial_roles: function() {
      let roles = [];
      this.roles.forEach(el => {
        const instance = this.selected_roles.find(id => id === el._id);
        if (!instance) roles.push(el);
      });
      return roles;
    }
  },
  methods: {
    onChange(value) {
      this.value = value;
      this.emitData();
    },
    onRoleSelected(role) {
      this.selected_roles.push(role._id);
      this.emitData();
    },
    onRoleDelete(index) {
      this.selected_roles.splice(index, 1);
      this.emitData();
    },
    emitData() {
      let data = { value: this.value };
      if (this.value === "role_list") {
        data.role_list = this.selected_roles;
      }
      this.$emit("change", data);
    }
  }
};
</script>

<style lang="scss" scoped>
.view-calls {
  font-size: 13px;
}
</style>
