<template>
  <div class="card-contacts">
    <div v-if="contacts.length > 0">
      <contact
        @deleteContact="$emit('onDeleteContact', $event)"
        v-for="(contact, i) in contacts_array"
        :key="contact._id"
        :contact="contact"
        :index="i"
      ></contact>
      <button
        class="card-contacts__show-button"
        v-if="contacts.length > 3"
        @click="show_all_contacts = !show_all_contacts"
      >
        {{ show_all_contacts ? "Скрыть" : "Показать все" }} контакты
      </button>
    </div>
    <div v-else class="card-contacts__empty">
      Здесь пока нет ни одного контакта
    </div>
  </div>
</template>

<script>
import contact from "./contacts/contact.vue";

export default {
  props: {
    contacts: {
      type: Array,
      default: () => []
    }
  },
  data: () => ({
    show_all_contacts: false
  }),
  computed: {
    contacts_array: function() {
      let contacts = [...this.contacts];
      if (this.show_all_contacts) return contacts;
      return contacts.slice(0, 3);
    }
  },
  components: {
    contact
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.card-contacts {
  margin-top: 0.3rem;
  border-radius: 3px;
  background-color: $oc-gray-1;

  &__show-button {
    background-color: $oc-gray-2;
    border: none;
    width: 100%;
    padding: 0.25rem 0;
    color: $oc-gray-8;
    transition: 0.2s;
    outline: none;

    &:hover {
      background-color: $oc-gray-3;
    }
  }

  &__empty {
    padding: 1rem;
    font-weight: 600;
    display: flex;
    justify-content: center;
  }
}
</style>
