<template>
  <div>
    <transition-group name="fade">
      <component
        v-for="item in modals"
        :key="item.name"
        :is="item.name"
        :options="item"
      />
    </transition-group>
  </div>
</template>
<script>
import boardSettings from "./modals/board-settings.vue";
import columnSettings from "./modals/column-settings.vue";
import boardPermissions from "./modals/board-permissions.vue";
import columnPermissions from "./modals/column-permissions.vue";
import openedCard from "./modals/opened-card.vue";
import addCard from "./modals/add-card.vue";
import addContact from "./modals/opened-card/add-contact.vue";
import addAttachment from "./modals/opened-card/add-attachment.vue";
import closeCommand from "./modals/opened-card/close-command.vue";
import autoAddMembers from "./modals/auto-add-members.vue";
import editMembers from "./modals/opened-card/edit-members.vue";
import addColumn from "./modals/add-column.vue";
import addBoard from "./modals/add-board.vue";
import globalPermissions from "./modals/global-permissions.vue";
import manageTokens from "./modals/manage-tokens.vue";
import filterCards from "./modals/filter-cards.vue";
import editServices from "./modals/opened-card/edit-services.vue";
import otherColumnSettings from "./modals/other-column-settings.vue";
import qrAuth from "./modals/qr-auth.vue";
import pbxCardNotification from "./modals/pbx-card-notification.vue";
import editAttachment from "./modals/opened-card/edit-attachment";
import checklistResponsibleUsers from "./modals/opened-card/checklist-responsible-users.vue";
import boardLabels from "./modals/board-labels.vue";

export default {
  data: () => ({
    modals: []
  }),
  created() {
    this.$modal.$on("open", options => {
      const modal = this.modals.find(o => o.name === options.name);
      if (!modal) this.modals.push(options);
    });

    this.$modal.$on("close", name => {
      const index = this.modals.findIndex(el => el.name === name);
      this.modals.splice(index, 1);
    });
  },
  components: {
    boardSettings,
    columnSettings,
    boardPermissions,
    columnPermissions,
    openedCard,
    addCard,
    addContact,
    addAttachment,
    closeCommand,
    autoAddMembers,
    editMembers,
    addColumn,
    addBoard,
    globalPermissions,
    manageTokens,
    filterCards,
    editServices,
    otherColumnSettings,
    qrAuth,
    pbxCardNotification,
    editAttachment,
    checklistResponsibleUsers,
    boardLabels
  }
};
</script>
