<template>
  <div class="main">
    <card-title
      :value="title"
      @change="onTitleChange"
      :disabled="!columnScopeHas(board_id, column_id, 'edit_card_title')"
    ></card-title>
    <card-section>
      <div class="d-flex justify-content-between align-items-center">
        <div>
          {{ board.name }} / {{ column.name }}
          <span
            v-if="card.deleteAction === true"
            :style="{ color: $oc.red[5], fontWeight: 600 }"
          >
            [Эта карточка будет удалена]</span
          >
        </div>
      </div>
      <div :style="{ fontSize: '13px' }">
        Дата создания:
        <span :style="{ fontWeight: 600 }">
          {{ created_at }}
        </span>
      </div>
    </card-section>
    <card-section v-if="card.labels && card.labels.length > 0">
      <div class="d-flex">
        <oy-label
          class="mr-2"
          v-for="(label, i) in card.labels"
          :key="i"
          :name="label.name"
          :color="label.color"
          :closable="boardScopeHas(board_id, 'edit_board_labels')"
          @close="onLabelDelete(i)"
        />
      </div>
    </card-section>
    <card-section v-if="schema.find(el => el === 'cardAddress')" title="Адрес">
      <card-address
        :address="address"
        :disabled="!columnScopeHas(board_id, column_id, 'edit_card_address')"
        @change="onAddressChange"
      ></card-address>
    </card-section>
    <card-section
      v-if="schema.find(el => el === 'cardDescription')"
      title="Описание"
    >
      <card-description
        :description="description"
        :disabled="
          !columnScopeHas(board_id, column_id, 'edit_card_description')
        "
        @change="onDescriptionChange"
      ></card-description>
    </card-section>
    <card-checklists
      v-if="
        schema.find(el => el === 'cardChecklists') &&
          checklists.length > 0 &&
          columnScopeHas(board_id, column_id, 'view_card_checklists')
      "
      :checklists="checklists"
    />
    <card-section
      v-if="schema.find(el => el === 'cardContacts')"
      title="Контакты"
    >
      <oy-feather-icon
        v-if="
          !$route.query.card_id ||
            columnScopeHas(board_id, column_id, 'add_card_contacts')
        "
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
      <card-contacts :contacts="contacts"></card-contacts>
    </card-section>
    <card-section
      v-if="
        schema.find(el => el === 'cardManagerProfile') &&
          componentsVisible.manager_profile &&
          columnScopeHas(board_id, column_id, 'view_manager_profile')
      "
      title="Анкета менеджера"
    >
      <card-manager-profile
        :profile="manager_profile"
        @change="onManagerProfileChange"
        :disabled="!columnScopeHas(board_id, column_id, 'edit_manager_profile')"
      ></card-manager-profile>
    </card-section>
    <card-section
      v-if="
        schema.find(el => el === 'cardExploringProfile') &&
          componentsVisible.exploring_profile &&
          columnScopeHas(board_id, column_id, 'view_exploring_profile')
      "
      title="Разведка"
    >
      <card-exploring-profile
        :profile="exploring_profile"
        @change="onExploringProfileChange"
        :disabled="
          !columnScopeHas(board_id, column_id, 'edit_exploring_profile')
        "
      ></card-exploring-profile>
    </card-section>
    <card-section
      v-if="
        schema.find(el => el === 'cardOperator') &&
          componentsVisible.operator &&
          columnScopeHas(board_id, column_id, 'view_card_operators')
      "
      title="Оператор"
    >
      <card-operator
        :operator="operator"
        :disabled="!columnScopeHas(board_id, column_id, 'edit_card_operators')"
        @change="onOperatorChange"
      ></card-operator>
    </card-section>
    <card-section
      v-if="
        schema.find(el => el === 'cardClient') &&
          componentsVisible.client &&
          columnScopeHas(board_id, column_id, 'view_card_clients')
      "
      title="Клиент"
    >
      <card-client
        :client="client"
        :disabled="!columnScopeHas(board_id, column_id, 'edit_card_clients')"
        @change="onClientChange"
      ></card-client>
    </card-section>

    <card-section title="Узел">
      <node
        @connectionTypeSelected="onConnectionTypeSelected"
        @nodeSelected="onNodeSelected"
      />
    </card-section>

    <card-section
      v-if="schema.find(el => el === 'cardAttachments') && attachments"
      title="Вложения"
    >
      <card-attachments :attachments="attachments"></card-attachments>
    </card-section>
    <comment-editor
      v-if="schema.find(el => el === 'cardEvents') && userIsMember"
    ></comment-editor>
    <card-section v-if="schema.find(el => el === 'cardEvents')">
      <card-events></card-events>
    </card-section>
  </div>
</template>

<script>
import permissionsMixin from "./permissionsMixin";
import cardComponentsMixin from "../../common/cardComponentsMixin";
import cardSection from "./main/section.vue";
import cardTitle from "./main/title.vue";
import cardAddress from "./main/address.vue";
import cardDescription from "./main/description.vue";
import cardContacts from "./main/contacts.vue";
import cardManagerProfile from "./main/manager-profile.vue";
import cardExploringProfile from "./main/exploring-profile.vue";
import cardOperator from "./main/operator.vue";
import cardClient from "./main/client.vue";
import cardAttachments from "./main/attachments.vue";
import cardEvents from "./main/events.vue";
import commentEditor from "./main/comments/editor";
import cardChecklists from "./main/checklists";
import cardService from "../../../services/cardService";
import moment from "moment";
import Node from "@/components/board-page/opened-card/main/node";

export default {
  mixins: [permissionsMixin, cardComponentsMixin],
  props: {
    componentsVisible: {
      type: Object,
      required: true
    }
  },
  computed: {
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    schema: function() {
      return this.column.cards_schema
        ? this.column.cards_schema
        : this.cardComponents.map(el => el.name);
    },
    created_at: function() {
      if (!this.card.created_at) return "Не указано";
      else {
        return moment(this.card.created_at).format("DD.MM.YYYY H:mm:ss");
      }
    },
    board: function() {
      return this.$store.getters["kanban/boards/instance"](this.card.board_id);
    },
    column: function() {
      return this.$store.getters["kanban/columns/instance"](
        this.card.column_id
      );
    },
    board_id: function() {
      return this.card?.board_id;
    },
    column_id: function() {
      return this.card?.column_id;
    },
    title: function() {
      return this.card?.title;
    },
    address: function() {
      return this.card?.address;
    },
    description: function() {
      return this.card?.description;
    },
    contacts: function() {
      return this.card?.contacts;
    },
    manager_profile: function() {
      return this.card?.manager_profile;
    },
    exploring_profile: function() {
      return this.card?.exploring_profile;
    },
    operator: function() {
      return this.card?.operator;
    },
    client: function() {
      return this.card?.client;
    },
    user: function() {
      return this.$store.getters["user/instance"];
    },
    userIsMember: function() {
      return this.card?.members?.find(el => el === this.user._id);
    },
    attachments: function() {
      return this.$store.getters["kanban/card/attachments/list"];
    },
    checklists: function() {
      return this.$store.getters["kanban/card/checklists/list"];
    }
  },
  components: {
    Node,
    commentEditor,
    cardSection,
    cardTitle,
    cardAddress,
    cardDescription,
    cardContacts,
    cardManagerProfile,
    cardExploringProfile,
    cardOperator,
    cardClient,
    cardAttachments,
    cardEvents,
    cardChecklists
  },
  methods: {
    setCardData({ card_id, payload }) {
      cardService.updateCard(this.card._id, payload);
      this.$store.commit("kanban/cards/setCardData", { card_id, payload });
      this.$echo
        .private(`board.${this.$route.params.board_id}`)
        .whisper("setCardData", { card_id, payload });
    },
    onTitleChange(title) {
      this.setCardData({
        card_id: this.card._id,
        payload: { title }
      });
    },
    onAddressChange(payload) {
      this.setCardData({
        card_id: this.card._id,
        payload
      });
    },
    onDescriptionChange(description) {
      this.setCardData({
        card_id: this.card._id,
        payload: { description }
      });
    },
    onClientChange(client) {
      this.setCardData({
        card_id: this.card._id,
        payload: { client }
      });
    },
    onOperatorChange(operator) {
      this.setCardData({
        card_id: this.card._id,
        payload: { operator }
      });
    },
    onExploringProfileChange(exploring_profile) {
      this.setCardData({
        card_id: this.card._id,
        payload: { exploring_profile }
      });
    },
    onManagerProfileChange(manager_profile) {
      this.setCardData({
        card_id: this.card._id,
        payload: { manager_profile }
      });
    },
    async onConnectionTypeSelected(connectionType) {
      this.setCardData({
        card_id: this.card._id,
        payload: { connectionType }
      });
    },
    async onNodeSelected(nodeName) {
      this.setCardData({
        card_id: this.card._id,
        payload: { nodeName }
      });
    },
    async onAddContact(contact) {
      const result = await cardService.storeCardContact(this.card._id, contact);
      this.$store.commit("kanban/cards/pushContact", {
        card_id: this.card._id,
        contact: result.data
      });
      this.$echo
        .private(`board.${this.$route.params.board_id}`)
        .whisper("pushContact", {
          card_id: this.card._id,
          contact: result.data
        });
    },
    async onLabelDelete(index) {
      const cardInstance = Object.assign({}, this.card);
      cardInstance.labels.splice(index, 1);
      this.setCardData({
        card_id: this.card._id,
        payload: { labels: cardInstance.labels }
      });
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.main {
}
</style>
