<template>
  <div class="card-description">
    <textarea
      :value="description"
      :disabled="disabled"
      @change="$emit('change', $event.target.value)"
      class="form-control"
      :style="{ fontSize: '13px' }"
    ></textarea>
  </div>
</template>

<script>
export default {
  props: {
    description: {
      type: String
    },
    disabled: {
      type: Boolean,
      default: false
    }
  }
};
</script>
