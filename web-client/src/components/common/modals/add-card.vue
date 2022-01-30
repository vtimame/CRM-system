<template>
  <wrapper :options="options" :emitCLick="true" @click="close">
    <div class="add-card row no-gutters">
      <div class="col-md-8">
        <card-title
          :value="card.title"
          @change="onTitleChange"
          @onErrorChange="validated.title = $event"
        ></card-title>
        <card-section
          v-if="schema.find(el => el === 'cardAddress')"
          title="Адрес"
        >
          <card-address
            :address="card.address"
            @change="onAddressChange"
            @onErrorChange="validated.address = $event"
          ></card-address>
        </card-section>
        <card-section
          v-if="schema.find(el => el === 'cardDescription')"
          title="Описание"
        >
          <card-description
            :description="card.description"
            @change="onDescriptionChange"
          ></card-description>
        </card-section>
        <card-section
          v-if="schema.find(el => el === 'cardContacts')"
          title="Контакты"
        >
          <oy-feather-icon
            slot="extra"
            type="user-plus"
            size="18"
            class="cursor-pointer"
            @click="
              $modal.open({
                name: 'add-contact',
                width: '350px',
                callback: onAddContact
              })
            "
          ></oy-feather-icon>
          <card-contacts
            :contacts="card.contacts"
            @onDeleteContact="onDeleteContact"
          ></card-contacts>
        </card-section>
      </div>
      <div
        class="col-md-4 p-2"
        :style="{
          backgroundColor: $oc.gray[1],
          borderLeft: `1px solid ${$oc.gray[3]}`
        }"
      >
        <aside-section title="Создатель карточки" class="mb-2">
          <lead-member :member="user"></lead-member>
        </aside-section>
        <aside-section title="Действия">
          <ul v-if="hasErrors" class="text-danger">
            <li v-if="!validated.title">Введите название карточки</li>
            <li
              v-if="
                !validated.address && schema.find(el => el === 'cardAddress')
              "
            >
              Введите адрес
            </li>
            <li
              v-if="
                !validated.contacts && schema.find(el => el === 'cardContacts')
              "
            >
              Создайте минимум один контакт
            </li>
          </ul>
          <oy-button
            type="success"
            class="btn-block"
            :disabled="hasErrors"
            @click="addCard"
            >Создать новую карточку</oy-button
          >
        </aside-section>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import cardSection from "../../board-page/opened-card/main/section.vue";
import cardTitle from "../../board-page/opened-card/main/title.vue";
import cardAddress from "../../board-page/opened-card/main/address.vue";
import cardDescription from "../../board-page/opened-card/main/description.vue";
import cardContacts from "../../board-page/opened-card/main/contacts.vue";
import asideSection from "../../board-page/opened-card/aside/section.vue";
import LeadMember from "../../board-page/opened-card/aside/lead-member";
import _set from "lodash/set";
import cardComponentsMixin from "../cardComponentsMixin";

export default {
  mixins: [modal, cardComponentsMixin],
  mounted() {
    this.card.board_id = this.$route.params.board_id;
    this.card.column_id = this.options.column._id;
    this.card.creator_id = this.user._id;
    this.card.members = [this.user._id];

    this.validated.address = !this.schema.find(el => el === "cardAddress");
    this.validated.contacts = !this.schema.find(el => el === "cardContacts");
  },
  data: () => ({
    validated: {
      title: false,
      address: false,
      contacts: false
    },
    card: {
      title: "",
      board_id: null,
      column_id: null,
      creator_id: null,
      manager_profile: {},
      exploring_profile: {},
      address: {
        street: "",
        street_num: "",
        litera: "",
        building: "",
        floor: "",
        office: "",
        room_type: "other"
      },
      contacts: [],
      members: []
    }
  }),
  computed: {
    schema: function() {
      return this.column.cards_schema
        ? this.column.cards_schema
        : this.cardComponents.map(el => el.name);
    },
    board: function() {
      return this.$store.getters["kanban/boards/instance"](
        this.$route.params.board_id
      );
    },
    column: function() {
      return this.$store.getters["kanban/columns/instance"](
        this.options.column._id
      );
    },
    user: function() {
      return this.$store.getters["user/instance"];
    },
    hasErrors: function() {
      const errors = [];
      Object.keys(this.validated).forEach(key => {
        if (this.validated[key] === false) errors.push(key);
      });
      return errors.length > 0;
    }
  },
  components: {
    LeadMember,
    cardSection,
    cardTitle,
    cardAddress,
    cardDescription,
    cardContacts,
    asideSection
  },
  methods: {
    async addCard() {
      await this.$store.dispatch("kanban/cards/addCard", this.card);
      this.close();
    },
    onAddContact(contact) {
      this.card.contacts.push(contact);
      if (
        this.card.contacts.length > 0 &&
        this.schema.find(el => el === "cardContacts")
      )
        this.validated.contacts = true;
    },
    onTitleChange(value) {
      this.card.title = value;
    },
    onDescriptionChange(value) {
      this.card.description = value;
    },
    onAddressChange(value) {
      const key = Object.keys(value)[0];
      const val = Object.values(value)[0];
      _set(this.card, key, val);
    },
    onDeleteContact(index) {
      this.card.contacts.splice(index, 1);
      if (this.card.contacts.length === 0) this.validated.contacts = false;
    }
  },
  watch: {
    "card.address": {
      handler(address, oldValue) {
        if (
          address.street &&
          address.street_num &&
          this.schema.find(el => el === "cardAddress")
        ) {
          this.validated.address = true;
        } else {
          this.validated.address = false;
        }
      },
      deep: true
    },
    "card.title": {
      handler(title, oldValue) {
        if (title.trim().length > 0) {
          this.validated.title = true;
        } else {
          this.validated.title = false;
        }
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.add-card {
  color: $oc-gray-8;
  font-size: 13px;
}
</style>
