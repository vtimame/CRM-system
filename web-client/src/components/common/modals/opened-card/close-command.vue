<template>
  <wrapper :options="options">
    <div class="close-command">
      <div class="close-command__header">Завершить {{ commandType }}</div>
      <div class="close-command__body">
        <div class="mb-2">
          <div>Отчет</div>
          <textarea v-model="report" class="form-control"></textarea>
        </div>
        <oy-select disabled-option="Выберите статус" v-model="status">
          <option
            v-for="item in status_types"
            :key="item.value"
            :value="item.value"
            >{{ item.title }}</option
          >
        </oy-select>
        <div class="mt-2">
          <button
            class="btn btn-success btn-sm"
            :disabled="disabled"
            @click="onClick"
          >
            Завершить
          </button>
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "../modal";
import wrapper from "../wrapper";

export default {
  mixins: [modal],
  data: () => ({
    status_types: [
      { title: "Завершено", value: "resolve" },
      { title: "Отклонено", value: "reject" }
    ],
    status: "",
    report: ""
  }),
  computed: {
    commandType: function() {
      switch (this.options.command.command_type) {
        case "call":
          return "звонок";
        case "meeting":
          return "встречу";
        default:
          return "";
      }
    },
    disabled: function() {
      return this.status === "" || this.report === "";
    }
  },
  methods: {
    onClick() {
      this.options.callback({
        status: this.status,
        report_message: this.report
      });
      this.close();
    }
  },
  components: {
    wrapper
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.close-command {
  font-size: 13px;

  &__header,
  &__body {
    padding: 0.5rem 1rem;
  }

  &__header {
    border-bottom: 1px solid $oc-gray-3;
    font-weight: 600;
  }
}
</style>
