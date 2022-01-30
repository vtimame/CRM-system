<template>
  <div class="aside">
    <div
      :style="{
        position: 'absolute',
        right: '11px',
        top: '5px',
        cursor: 'pointer'
      }"
      @click="$emit('close')"
    >
      <oy-feather-icon type="x" />
    </div>
    <aside-section title="добавить на карточку">
      <oy-action-button
        v-if="schema.find(el => el === 'cardAttachments')"
        @click="
          $modal.open({
            name: 'add-attachment',
            width: '550px'
          })
        "
        :disabled="!columnScopeHas(board_id, column_id, 'add_card_attachments')"
        >Вложение</oy-action-button
      >
      <oy-action-button
        v-if="schema.find(el => el === 'cardChecklists')"
        @click="createNewChecklist"
        :disabled="!columnScopeHas(board_id, column_id, 'add_card_checklists')"
        >Чек-лист</oy-action-button
      >
      <oy-action-button
        :disabled="!boardScopeHas(board_id, 'edit_board_labels')"
        @click="
          $modal.open({
            name: 'board-labels',
            width: '350px',
            position: 'top'
          })
        "
        >Метки</oy-action-button
      >
      <div
        v-if="columnScopeHas(board_id, column_id, 'add_card_checklists')"
        class="new_checklist"
        :class="{ 'new_checklist--active': new_checklist }"
      >
        <form @submit.prevent="onCreateChecklist">
          <oy-input
            v-model="checklist_title"
            :error="checklist_error ? ' ' : ''"
            placeholder="Новый чек-лист..."
            ref="checklist_title"
          />
          <oy-button class="my-2" :block="true" html-type="submit"
            >Создать</oy-button
          >
        </form>
        <oy-button
          class="my-2"
          :block="true"
          type="danger"
          @click="new_checklist = false"
          >Отмена</oy-button
        >
      </div>
    </aside-section>

    <aside-section title="Показать / Скрыть">
      <oy-action-button
        @click="$emit('changeVisible', 'manager_profile')"
        v-if="
          columnScopeHas(board_id, column_id, 'view_manager_profile') &&
            schema.find(el => el === 'cardManagerProfile')
        "
      >
        <span>Анкета менеджера</span>
        <oy-feather-icon
          slot="postfix"
          size="16"
          :type="`eye${componentsVisible.manager_profile ? '' : '-off'}`"
        ></oy-feather-icon>
      </oy-action-button>
      <oy-action-button
        @click="$emit('changeVisible', 'exploring_profile')"
        v-if="
          columnScopeHas(board_id, column_id, 'view_exploring_profile') &&
            schema.find(el => el === 'cardExploringProfile')
        "
      >
        <span>Разведка</span>
        <oy-feather-icon
          slot="postfix"
          size="16"
          :type="`eye${componentsVisible.exploring_profile ? '' : '-off'}`"
        ></oy-feather-icon>
      </oy-action-button>
      <!--      <oy-action-button @click="$emit('changeVisible', 'requisites')">-->
      <!--        <span>Реквизиты</span>-->
      <!--        <oy-feather-icon-->
      <!--          slot="postfix"-->
      <!--          size="16"-->
      <!--          :type="`eye${componentsVisible.requisites ? '' : '-off'}`"-->
      <!--        ></oy-feather-icon>-->
      <!--      </oy-action-button>-->
      <oy-action-button
        v-if="
          columnScopeHas(board_id, column_id, 'view_card_operators') &&
            schema.find(el => el === 'cardOperator')
        "
        @click="$emit('changeVisible', 'operator')"
      >
        <span>Оператор</span>
        <oy-feather-icon
          slot="postfix"
          size="16"
          :type="`eye${componentsVisible.operator ? '' : '-off'}`"
        ></oy-feather-icon>
      </oy-action-button>
      <oy-action-button
        v-if="
          columnScopeHas(board_id, column_id, 'view_card_clients') &&
            schema.find(el => el === 'cardClient')
        "
        @click="$emit('changeVisible', 'client')"
      >
        <span>Клиент</span>
        <oy-feather-icon
          slot="postfix"
          size="16"
          :type="`eye${componentsVisible.client ? '' : '-off'}`"
        ></oy-feather-icon>
      </oy-action-button>
    </aside-section>

    <aside-section
      v-if="schema.find(el => el === 'cardServices')"
      title="Услуги"
    >
      <oy-feather-icon
        v-if="columnScopeHas(board_id, column_id, 'edit_services')"
        type="edit"
        size="16"
        slot="extra"
        :style="{ cursor: 'pointer' }"
        @click="
          $modal.open({
            name: 'edit-services',
            position: 'top',
            width: '800px',
            card
          })
        "
      />
      <div class="aside__services mb-2" v-if="services && services.length > 0">
        <div
          class="aside__service mb-1"
          v-for="(service, i) in services"
          :key="i"
        >
          <div
            class="aside__service__title d-flex align-items-center justify-content-between"
          >
            <div>{{ service.title }}</div>
            <div
              v-if="columnScopeHas(board_id, column_id, 'view_services_price')"
              :style="{ fontWeight: 500 }"
            >
              {{ service.price }}₽
            </div>
          </div>
          <div class="d-flex align-items-center" :style="{ fontSize: '12px' }">
            <div v-for="(field, o) in service.fields" :key="o">
              <div class="mr-2">{{ field.value }} {{ field.title }}</div>
            </div>
          </div>
        </div>
      </div>
      <div
        v-else
        :style="{
          fontWeight: 600,
          fontSize: '13px',
          padding: '0.3rem',
          textAlign: 'center'
        }"
      >
        Здесь пока нет услуг
      </div>
    </aside-section>

    <aside-section title="Действия">
      <oy-action-button @click="onDeleteCard">{{
        systemScopeHas("delete_cards")
          ? "Удалить карточку"
          : "Попросить удалить карточку"
      }}</oy-action-button>
      <oy-action-button :disabled="true">Скопировать карточку</oy-action-button>
      <oy-action-button :disabled="true">Архивировать</oy-action-button>
      <oy-action-button :disabled="true">Переместить</oy-action-button>
    </aside-section>

    <aside-section
      :title="
        `${
          creator_id !== lead_id ? 'создатель' : 'создатель и ведущий'
        } карточки`
      "
    >
      <lead-member
        :member="$store.getters['users/instance'](creator_id)"
      ></lead-member>
    </aside-section>
    <aside-section
      v-if="lead_id && creator_id !== lead_id"
      title="Ведущий карточки"
    >
      <lead-member
        :is-lead="true"
        :member="$store.getters['users/instance'](lead_id)"
      ></lead-member>
    </aside-section>
    <aside-section title="Участники">
      <members :members="members"></members>
    </aside-section>
    <aside-section v-if="subscribers.length > 1" title="Сейчас просматривают">
      <div v-for="subscriber in subscribers" :key="subscriber._id">
        <lead-member v-if="user._id !== subscriber._id" :member="subscriber" />
      </div>
    </aside-section>
  </div>
</template>

<script>
import permissionsMixin from "./permissionsMixin";
import asideSection from "./aside/section.vue";
import members from "./aside/members.vue";
import leadMember from "./aside/lead-member.vue";
import cardComponentsMixin from "../../common/cardComponentsMixin";
import cardService from "@/services/cardService";

export default {
  mixins: [permissionsMixin, cardComponentsMixin],
  props: {
    componentsVisible: {
      type: Object,
      required: true
    }
  },
  data: () => ({
    new_checklist: false,
    checklist_title: "",
    private_checklist: false,
    checklist_error: false
  }),
  computed: {
    schema: function() {
      return this.column.cards_schema
        ? this.column.cards_schema
        : this.cardComponents.map(el => el.name);
    },
    user: function() {
      return this.$store.getters["user/instance"];
    },
    subscribers: function() {
      return this.$store.getters["kanban/card/subscribers"];
    },
    card: function() {
      return this.$store.getters["kanban/cards/instance"](
        this.$route.query.card_id
      );
    },
    board: function() {
      return this.$store.getters["kanban/boards/instance"](this.card.board_id);
    },
    column: function() {
      return this.$store.getters["kanban/columns/instance"](
        this.card.column_id
      );
    },
    services: function() {
      return this.card?.services;
    },
    board_id: function() {
      return this.card?.board_id;
    },
    column_id: function() {
      return this.card?.column_id;
    },
    creator_id: function() {
      return this.card?.creator_id;
    },
    lead_id: function() {
      return this.card?.lead_id;
    },
    members: function() {
      return this.card?.members;
    }
  },
  methods: {
    async onDeleteCard() {
      if (this.systemScopeHas("delete_cards")) {
        this.$store.dispatch("kanban/cards/deleteCard", this.card._id).then();
        this.$modal.$emit("close-opened-card");
      } else {
        await cardService.updateCard(this.card._id, {
          deleteAction: true
        });
        this.$store.commit("kanban/cards/setCardData", {
          card_id: this.$route.query.card_id,
          payload: { deleteAction: true }
        });
      }
    },
    createNewChecklist() {
      this.new_checklist = !this.new_checklist;
      this.$refs.checklist_title.focus();
    },
    async onCreateChecklist() {
      this.checklist_error = false;
      if (this.checklist_title.length > 0) {
        await this.$store.dispatch("kanban/card/checklists/storeChecklist", {
          title: this.checklist_title,
          card_id: this.card._id,
          creator_id: this.user._id,
          points: []
        });
        this.new_checklist = false;
        this.checklist_title = "";
      } else this.checklist_error = true;
    }
  },
  components: {
    asideSection,
    members,
    leadMember
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.aside {
  padding: 0.5rem 1rem;

  &__service {
    color: $oc-blue-5;

    &__title {
      font-weight: 600;
    }
  }

  .new_checklist {
    max-height: 0;
    overflow-y: hidden;
    transition: 0.5s ease-in-out;

    &--active {
      max-height: 500px;
      transition: 0.4s ease-in-out;
    }
  }
}
</style>
