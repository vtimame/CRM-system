<template>
  <div class="card-main">
    <card-title :title="card.title"></card-title>
    <card-section title="Адрес">
      <card-address :address="card.address"></card-address>
    </card-section>
    <card-section title="Описание">
      <card-description
        :description="card.description !== null ? card.description : ''"
      ></card-description>
    </card-section>
    <card-section title="Контакты">
      <card-contacts :contacts="card.contacts"></card-contacts>
    </card-section>
    <card-section title="Анкета менеджера">
      <card-manager-profile
        :profile="card.manager_profile !== null ? card.manager_profile : {}"
      ></card-manager-profile>
    </card-section>
    <card-section title="Оператор">
      <card-operator></card-operator>
    </card-section>
    <card-section title="Клиент">
      <card-client></card-client>
    </card-section>
    <card-section title="Анкета разведки">
      <card-exploring-profile
        :profile="card.exploring_profile !== null ? card.exploring_profile : {}"
      ></card-exploring-profile>
    </card-section>
    <card-section title="Реквизиты">
      <card-requisites></card-requisites>
    </card-section>
    <card-section title="Комментарии">
      <card-comments></card-comments>
    </card-section>
  </div>
</template>

<script>
import cardSection from './card-main/section.vue';
import cardTitle from './card-main/title.vue';
import cardAddress from './card-main/address.vue';
import cardDescription from './card-main/description.vue';
import cardContacts from './card-main/contacts.vue';
import cardManagerProfile from './card-main/manager-profile.vue';
import cardOperator from './card-main/operator.vue';
import cardClient from './card-main/client.vue';
import cardExploringProfile from './card-main/exploring-profile.vue';
import cardRequisites from './card-main/requisites.vue';
import cardComments from './card-main/comments.vue';

export default {
  computed: {
    card: function () {
      return this.$store.getters['kanban/card/instance'];
    },
  },
  components: {
    cardSection,
    cardTitle,
    cardAddress,
    cardDescription,
    cardContacts,
    cardManagerProfile,
    cardOperator,
    cardClient,
    cardExploringProfile,
    cardRequisites,
    cardComments,
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.card-main {
  border-right: 1px solid $oc-gray-2;
}
</style>
