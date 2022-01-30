import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import oyui from "./plugins/oyui";
import axios from "./plugins/axios";
import validation from "./plugins/validation";
import Directives from "./plugins/directives";
import { loadProgressBar } from "axios-progress-bar";
import utils from "./plugins/utils";
import Lightbox from "vue-easy-lightbox";
import infiniteScroll from "vue-infinite-scroll";
import Toast from "vue-toastification";
import VCalendar from "v-calendar";
//sentry
import * as Sentry from "@sentry/browser";
import { Vue as VueIntegration } from "@sentry/integrations";
import { Integrations } from "@sentry/tracing";


// import firebase from "firebase/app";
// import messaging from "firebase/messaging";
import { isIOS } from "mobile-device-detect";

import "./assets/sass/app.scss";
import "axios-progress-bar/dist/nprogress.css";
import "vue2-datepicker/index.css";
import "filepond/dist/filepond.min.css";
import "vue-toastification/dist/index.css";

import permissions from "./plugins/utils/permissions";
import notifications from "./plugins/notifications";

loadProgressBar({ showSpinner: false });

Vue.config.productionTip = false;
Vue.use(oyui);
Vue.use(VCalendar);
Vue.use(Toast, {});
Vue.use(axios);
Vue.use(validation);
Vue.use(Directives);
Vue.use(utils);
Vue.use(permissions);
Vue.use(notifications);
Vue.use(Lightbox);
Vue.use(infiniteScroll);

if (!isIOS && Notification !== undefined) {
  Notification.requestPermission();
}

// firebase.initializeApp({
//   apiKey: "AIzaSyDjTdSiZHVy3JZaaHUEmK2D9_uSLZV500c",
//   authDomain: "oycrm-78955.firebaseapp.com",
//   databaseURL: "https://oycrm-78955.firebaseio.com",
//   projectId: "oycrm-78955",
//   storageBucket: "oycrm-78955.appspot.com",
//   messagingSenderId: "222749112128",
//   appId: "1:222749112128:web:5091cf1754a9e4827c6ca5"
// });
//
// console.log(messaging);

if (process.env.VUE_APP_SENTRY_DSN) {
    console.log(123)
    Sentry.init({
        dsn: process.env.VUE_APP_SENTRY_DSN,
        integrations: [
            new VueIntegration({
                Vue,
                tracing: true
            }),
            new Integrations.BrowserTracing()
        ],
        tracesSampleRate: 1.0
    })
}

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
