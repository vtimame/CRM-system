<template>
  <profile-section>
    <div class="outsourcing">
      <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>IT Аутсорсинг</span>
          <oy-radio-button
            :disabled="disabled"
            :value="it_outsourcing"
            @change="$emit('change', { value: $event, key: 'it_outsourcing' })"
          ></oy-radio-button>
        </div>
      </div>
    </div>
  </profile-section>
</template>

<script>
import profileSection from "./section.vue";

export default {
  props: ["it_outsourcing", "disabled"],
  components: {
    profileSection
  }
};
</script>
