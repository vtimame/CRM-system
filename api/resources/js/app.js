import Vue from 'vue';
import App from './App.vue';
import Echo from 'laravel-echo';
import { router } from './router';
import { store } from './vuex';
import { Axios } from './plugins/axios';
import { loadProgressBar } from 'axios-progress-bar';
import { OpenColor } from './plugins/open-color';
import { Modals } from './plugins/modals';

loadProgressBar();

import 'ant-design-vue/dist/antd.css';
import 'axios-progress-bar/dist/nprogress.css';

Vue.config.productionTip = false;
Vue.use(Axios);
Vue.use(OpenColor);
Vue.use(Modals);

// window.io = require('socket.io-client');
// if (typeof io !== 'undefined') {
//   window.Echo = new Echo({
//     broadcaster: 'socket.io',
//     host: window.location.hostname + ':6001',
//   });
// }
//
// window.Echo.channel('oycrm_database_test-event')
//     .listen('ExampleEvent', (e) => {
//         console.log(e);
//     });

new Vue({
  el: '#app',
  router,
  store,
  render: (h) => h(App),
});
