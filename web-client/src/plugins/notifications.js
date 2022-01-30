import Vue from "vue";
import store from "../store";
import router from "../router";

const notification = {
  data: null,
  send(data) {
    this.data = data;
    if (!("Notification" in window)) {
      alert("This browser does not support desktop notification");
    } else if (Notification.permission === "granted") {
      this.createNotification();
    } else if (Notification.permission !== "denied") {
      Notification.requestPermission(function(permission) {
        if (permission === "granted") {
          this.createNotification();
        }
      });
    }
  },
  createNotification() {
    let message;
    switch (this.data.type) {
      case "cardCommentWasAdded":
        message = this.cardCommentWasAdded();
        break;
      case "cardAnswerWasAdded":
        message = this.cardAnswerWasAdded();
        break;
      case "cardContactWasAdded":
        message = this.cardContactWasAdded();
        break;
      case "cardMemberWasAdded":
        message = this.cardMemberWasAdded();
        break;
      case "cardMentionWasAdded":
        message = this.cardMentionWasAdded();
        break;
      case "cardWasMoved":
        message = this.cardWasMoved();
        break;
      case "userMustCall":
        message = this.userMustCall();
        break;
      case "userMustMeeting":
        message = this.userMustMeeting();
        break;
      case "remindCardActivity":
        message = this.remindCardActivity();
        break;
      case "reportExpiredEvents":
        message = this.reportExpiredEvents();
        break;
      case "newSiteTicket":
        message = this.newSiteTicket();
        break;
      default:
        message = "Произошло что-то странное";
        break;
    }

    const notificationInstance = new Notification(message);
    notificationInstance.onclick = () => this.pushInCard();
  },
  getInitiator() {
    return store.getters["users/instance"](this.data.initiator_id);
  },
  getCard() {
    return store.getters["kanban/cards/instance"](this.data.card_id);
  },
  getColumn(id) {
    return store.getters["kanban/columns/instance"](id);
  },
  cardCommentWasAdded() {
    return `${this.getInitiator().surname} ${
      this.getInitiator().name
    } оставил комментарий в карточке ${this.getCard().title}`;
  },
  remindCardActivity() {
    return `В карточке ${
      this.getCard().title
    } за последние 24 часа не было изменений`;
  },
  cardAnswerWasAdded() {
    return `${this.getInitiator().surname} ${
      this.getInitiator().name
    } ответил на ваш комментарий в карточке ${this.getCard().title}`;
  },
  cardContactWasAdded() {
    return `${this.getInitiator().surname} ${
      this.getInitiator().name
    } добавил новый контакт в карточке ${this.getCard().title}`;
  },
  cardMemberWasAdded() {
    return `${this.getInitiator().surname} ${
      this.getInitiator().name
    } добавил вас в карточку ${this.getCard().title}`;
  },
  cardMentionWasAdded() {
    return `${this.getInitiator().surname} ${
      this.getInitiator().name
    } упомянул вас в карточке ${this.getCard().title}`;
  },
  cardWasMoved() {
    return `${this.getInitiator().surname} ${
      this.getInitiator().name
    } перенес карточку ${this.getCard().title} из ${
      this.getColumn(this.data.old_column_id).name
    } в ${this.getColumn(this.data.new_column_id).name}`;
  },
  userMustCall() {
    return `У вас запланирован звонок по карточке ${this.getCard().title}`;
  },
  userMustMeeting() {
    return `У вас запланирована встреча по карточке ${this.getCard().title}`;
  },
  reportExpiredEvents() {
    return `${this.getInitiator().surname} ${
      this.getInitiator().name
    } просрочил${this.getInitiator().sex === 0 ? "" : "а"} ${
      this.data.command_type === "call" ? "звонок" : "встречу"
    }`;
  },
  newSiteTicket() {
    return `На вас назначена заявка ${this.getCard().title}`;
  },
  async pushInCard() {
    const route = router.currentRoute;
    let options = { query: { card_id: this.getCard()._id } };
    // await store.dispatch("kanban/card/loadCard", this.data.card_id);
    if (route.name !== "board-page") {
      options.name = "board-page";
      options.params = { board_id: this.getCard().board_id };
    } else if (route.params.board_id !== this.getCard().board_id) {
      options.params = { board_id: this.getCard().board_id };
    }

    await router.push(options);
    if (route.name === "board-page") {
      Vue.prototype.$modal.open({
        name: "opened-card",
        width: "850px",
        position: "top"
      });
    }
  }
};

export default {
  install: Vue => {
    Vue.prototype.$notification = notification;
  }
};
