<template>
  <div class="card-contact" @click="showAllData">
    <div class="card-contact__data">
      <div class="card-contact__meta">
        <div class="card-contact__name">
          {{ contact.surname }} {{ contact.name }} {{ contact.patronymic }}
        </div>
        <div class="card-contact__position">{{ contact.position }}</div>
        <div class="card-contact__email">{{ contact.email }}</div>
        <div v-if="show_all_data">
          <a
            href="#"
            v-if="
              !$route.query.card_id ||
                columnScopeHas(
                  card.board_id,
                  card.column_id,
                  'edit_card_contacts'
                )
            "
            @click.prevent="editContact"
            class="card-contact__action mr-2"
            >Изменить</a
          >
          <a
            href="#"
            v-if="
              !$route.query.card_id ||
                columnScopeHas(
                  card.board_id,
                  card.column_id,
                  'delete_card_contacts'
                )
            "
            @click.prevent="deleteContact(index)"
            class="card-contact__action text-danger"
            >Удалить</a
          >
        </div>
      </div>
      <div class="card-contact__phones">
        <div class="card-contact__phone" v-for="item in phones" :key="item._id">
          <span>{{ $utils.formatPhone(item.phone) }}</span>
          <span v-if="item.additional">&nbsp;доб. {{ item.additional }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import cardService from "../../../../../services/cardService";

export default {
  props: {
    contact: {
      type: Object,
      required: true
    },
    index: {
      type: Number,
      required: true
    }
  },
  data: () => ({
    show_all_data: false
  }),
  computed: {
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    phones: function() {
      let phones = [...this.contact.phones];
      if (this.show_all_data) return phones;
      return phones.splice(0, 3);
    }
  },
  methods: {
    showAllData(event) {
      if (event.target.closest(".card-contact__action") === null) {
        this.show_all_data = !this.show_all_data;
      }
    },
    editContact() {
      this.$modal.open({
        name: "add-contact",
        width: "350px",
        contact: this.contact,
        callback: this.onUpdateContact
      });
    },
    async deleteContact(index) {
      if (!this.$route.query.card_id) {
        this.$emit("deleteContact", index);
      } else {
        await cardService.deleteCardContact(
          this.$route.query.card_id,
          this.contact._id
        );
        this.$store.commit("kanban/cards/deleteContact", {
          card_id: this.card._id,
          contact_id: this.contact._id
        });
        this.$echo
          .private(`board.${this.$route.params.board_id}`)
          .whisper("deleteContact", {
            card_id: this.card._id,
            contact_id: this.contact._id
          });
      }
    },
    async onUpdateContact(contact) {
      if (!this.$route.query.card_id) return false;
      const result = await cardService.updateCardContact(
        this.$route.query.card_id,
        contact
      );
      this.$store.commit("kanban/cards/updateContact", {
        card_id: this.card._id,
        contact: result.data
      });
      this.$echo
        .private(`board.${this.$route.params.board_id}`)
        .whisper("updateContact", {
          card_id: this.card._id,
          contact: result.data
        });
    }
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-contact {
  padding: 0.5rem 1rem;
  border-bottom: 1px solid $oc-gray-2;
  transition: 0.2s ease-in-out;
  cursor: pointer;

  &__data {
    display: flex;
  }

  &:hover {
    background-color: $oc-gray-2;
  }

  &:last-child {
    border-bottom: none;
  }

  &__name {
    color: $oc-green-7;
    font-weight: 600;
  }

  &__position,
  &__email {
    font-size: 12px;
    line-height: 14px;
  }

  &__phones {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
  }
}
</style>
