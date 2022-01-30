<template>
  <wrapper :options="options" :emitCLick="true" @click="close">
    <div class="opened-card row no-gutters" v-if="card !== undefined">
      <div
        v-if="cover"
        class="col-12 opened-card__cover d-flex justify-content-end align-items-end px-3 py-2"
        :style="{ backgroundImage: `url(${cover_image})` }"
      >
        <button
          v-if="
            columnScopeHas(card.board_id, card.column_id, 'edit_card_cover')
          "
          class="opened-card__remove-cover-button"
          @click="onCoverDelete"
        >
          Удалить обложку
        </button>
      </div>
      <div class="col-md-8">
        <card-main
          :componentsVisible="visible"
          @open-mobile-aside="mobileCardAsideVisible = true"
        ></card-main>
      </div>
      <div
        class="col-md-4"
        :style="{
          backgroundColor: $oc.gray[1],
          borderLeft: `1px solid ${$oc.gray[3]}`
        }"
      >
        <card-aside
          :componentsVisible="visible"
          @changeVisible="onChangeVisible"
          @close="close"
        ></card-aside>
      </div>
    </div>
    <div
      v-else
      class="opened-card p-3 d-flex justify-content-center"
      :style="{ fontWeight: 600, fontSize: '1rem' }"
    >
      <div v-if="card_not_found">
        <span v-if="rawInstance">У вас нет прав на просмотр этой карточки</span>
        <span v-else>Вы открыли несуществующую карточку</span>
      </div>
      <SyncLoader v-if="!card_not_found" :color="$oc.blue[5]" />
    </div>
  </wrapper>
</template>

<script>
import modal from "./modal";
import cardMain from "../../../components/board-page/opened-card/main.vue";
import cardAside from "../../../components/board-page/opened-card/aside.vue";
import cardService from "../../../services/cardService";
import SyncLoader from "vue-spinner/src/SyncLoader.vue";

export default {
  mixins: [modal],
  mounted() {
    this.$modal.$on("close-opened-card", () => {
      this.close();
    });

    if (this.notifications.length > 0) {
      this.$store.dispatch(
        "user/notifications/markAllAsRead",
        this.notifications.map(el => el._id)
      );
    }
    this.listenCardChannel();
    if (this.loaded_board_id === this.$route.params.board_id) {
      this.load_additional_data();
    }
  },
  data: () => ({
    card_loaded: false,
    card_not_found: false,
    mobileCardAsideVisible: false,
    visible: {
      manager_profile: false,
      exploring_profile: false,
      requisites: false,
      operator: false,
      client: false
    }
  }),
  computed: {
    card_id: function() {
      return this.$route.query.card_id;
    },
    loaded_board_id: function() {
      return this.$store.getters["kanban/cards/board_id"];
    },
    rawInstance: function() {
      return this.$store.getters["kanban/cards/rawInstance"](
        this.$route.query.card_id
      );
    },
    card: function() {
      return this.$store.getters["kanban/cards/instance"](this.card_id);
    },
    cover: function() {
      return this.card?.cover;
    },
    cover_image: function() {
      return `${this.$api.url}/${this.$api.attachments_path}/${this.card._id}/thumbnails/w_900_${this.card.cover.name}`;
    },
    notifications: function() {
      return this.$store.getters["user/notifications/notRead"]?.filter(
        el => el.event?.card_id === this.$route.query.card_id
      );
    }
  },
  components: {
    cardMain,
    cardAside,
    SyncLoader
  },
  methods: {
    load_additional_data() {
      try {
        this.$store.dispatch(
          "kanban/card/attachments/loadAttachments",
          this.card.attachments
        );
        this.$store.dispatch(
          "kanban/card/checklists/loadChecklists",
          this.card_id
        );
        this.$store.dispatch("kanban/card/events/loadEvents", this.card_id);
        this.card_loaded = true;
      } catch (e) {
        this.card_not_found = true;
        throw e;
      }
    },
    close() {
      this.$modal.close(this.options.name);
      this.$store.commit("kanban/card/events/setEventsList", []),
        this.$store.commit("kanban/card/attachments/setAttachmentsList", []);
      this.$echo.leave(`presence-card.${this.$route.query.card_id}`);
      this.$echo.leave(`private-card.${this.$route.query.card_id}`);
      let query = Object.assign({}, this.$route.query);
      delete query.card_id;
      this.$router.push({ query });
    },
    onChangeVisible(key) {
      this.visible[key] = !this.visible[key];
    },
    async onCoverDelete() {
      await cardService.updateCard(this.card._id, {
        cover_id: null
      });
      this.$store.commit("kanban/cards/setCover", {
        card_id: this.$route.query.card_id,
        attachment: null
      });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.$route.query.card_id,
        payload: { cover_id: null }
      });
    },
    listenCardChannel() {
      this.$echo
        .join(`card.${this.$route.query.card_id}`)
        .here(users => {
          this.$store.commit("kanban/card/setSubscribers", users);
        })
        .joining(user => {
          this.$store.commit("kanban/card/pushSubscriber", user);
        })
        .leaving(user => {
          this.$store.commit("kanban/card/deleteSubscriber", user._id);
        });
      // .listen("CardWasChanged", this.updateCardData)
    }
  },
  watch: {
    $route(to, from) {
      if (from.query.card_id && to.params.board_id) {
        this.$modal.$emit("close-opened-card");
      }
    },
    loaded_board_id: function() {
      this.load_additional_data();
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.opened-card {
  color: $oc-gray-8;
  font-size: 13px;

  &__cover {
    height: 150px;
    border-bottom: 1px solid $oc-gray-3;
    background-size: cover;
    background-position: center top;
    border-radius: 3px 3px 0 0;
  }

  &__remove-cover-button {
    border: none;
    background-color: rgba(255, 255, 255, 0.3);
    font-size: 13px;
    color: $oc-gray-8;
    padding: 0.2rem 1rem;
    cursor: pointer;
    transition: 0.2s;
    outline: none;

    &:hover {
      background-color: rgba(255, 255, 255, 0.5);
    }
  }
}
</style>
