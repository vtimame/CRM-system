<template>
  <div class="card-requisites">
    <requisites-section>
      <div class="row">
        <div class="col-12">
          <div>Форма собственности</div>
          <oy-select
            disabled-option="Укажите форму собственности"
            :value="''"
          ></oy-select>
        </div>
      </div>
    </requisites-section>
    <requisites-section>
      <div class="row">
        <div class="col-12">
          <div>Юридическое наименование</div>
          <oy-input />
        </div>
      </div>
      <div class="row mt-2">
        <div class="col-6">
          <div>Адрес для документов</div>
          <oy-input />
        </div>
        <div class="col-6">
          <div>Юридический адрес</div>
          <oy-input />
        </div>
      </div>
      <div class="row mt-2">
        <div class="col-6">
          <div>ИНН</div>
          <oy-input />
        </div>
        <div class="col-6">
          <div>КПП</div>
          <oy-input />
        </div>
      </div>
      <div class="row mt-2">
        <div class="col-6">
          <div>БИК</div>
          <oy-input />
        </div>
        <div class="col-6">
          <div>Р/С</div>
          <oy-input />
        </div>
      </div>
      <div class="row mt-2">
        <div class="col-6">
          <div>Лицевой счет</div>
          <oy-input />
        </div>
        <div class="col-6">
          <div>Банк</div>
          <oy-input />
        </div>
      </div>
      <div class="row mt-2">
        <div class="col-6">
          <div>К/С</div>
          <oy-input />
        </div>
        <div class="col-6">
          <div>Лицо имеющее право подписи</div>
          <oy-input />
        </div>
      </div>
      <div class="row mt-2">
        <div class="col-6">
          <div>В родительном падеже</div>
          <oy-input />
        </div>
        <div class="col-6">
          <div>На основании</div>
          <oy-select :value="''"></oy-select>
        </div>
      </div>
    </requisites-section>
  </div>
</template>

<script>
import requisitesSection from "./manager-profile/section.vue";

export default {
  components: {
    requisitesSection
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-requisites {
  background-color: $oc-gray-1;
  border-radius: 3px;
  color: $oc-gray-8;
  margin-top: 0.3rem;
}
</style>
