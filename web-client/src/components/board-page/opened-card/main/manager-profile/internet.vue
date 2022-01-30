<template>
  <profile-section>
    <div class="internet">
      <div class="row">
        <div class="col-6 d-flex align-items-center justify-content-between">
          <span>Интернет</span>
          <oy-radio-button
            :value="internet"
            :disabled="disabled"
            @change="$emit('change', { value: $event, key: 'internet' })"
          ></oy-radio-button>
        </div>
        <!--        <div-->
        <!--          v-if="internet === true"-->
        <!--          class="col-6 d-flex align-items-center justify-content-between"-->
        <!--        >-->
        <!--          <span>Скорость</span>-->
        <!--          <oy-input-->
        <!--            :disabled="disabled"-->
        <!--            v-only-numbers-->
        <!--            class="pl-3"-->
        <!--            postfix="Мбит/с"-->
        <!--            :value="internet_speed"-->
        <!--            @change="$emit('change', { value: $event, key: 'internet_speed' })"-->
        <!--          />-->
        <!--        </div>-->
      </div>
    </div>
  </profile-section>
</template>

<script>
import profileSection from "./section.vue";

export default {
  props: ["internet", "internet_speed", "disabled"],
  components: {
    profileSection
  },
  methods: {}
};
</script>
