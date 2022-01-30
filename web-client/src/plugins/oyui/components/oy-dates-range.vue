<template>
  <div class="oy-dates-range">
    <date-picker
      mode="range"
      :value="range || dates"
      @input="$emit('change', $event)"
    />
  </div>
</template>

<script>
import DatePicker from "v-calendar/lib/components/date-picker.umd";
export default {
  props: {
    range: {
      type: Object
    }
  },
  computed: {
    dates: function() {
      const date = new Date(),
        y = date.getFullYear(),
        m = date.getMonth();
      const start = new Date(y, m, 1);
      const end = new Date(y, m + 1, 0);

      return {
        start,
        end
      };
    }
  },
  components: {
    DatePicker
  }
};
</script>

<style lang="scss">
.oy-dates-range {
  input {
    font-size: 13px;
    padding: 0.37rem 1rem;
  }
}
</style>
