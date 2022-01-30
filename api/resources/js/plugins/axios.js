import axios from 'axios';
import { store } from '../vuex';
import { router } from '../router';
import Notification from 'ant-design-vue/lib/notification';

let token = document.head.querySelector('meta[name="csrf-token"]');

if (token) {
  axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content;
}

axios.defaults.baseURL = process.env.MIX_API_URL;

axios.interceptors.request.use(
  function (config) {
    store.commit('app/clear_http_errors');
    const token = store.getters['auth/token'];
    if (token !== null) config.headers['Authorization'] = `Bearer ${token}`;

    return config;
  },
  function (error) {
    return Promise.reject(error);
  }
);

axios.interceptors.response.use(
  function (response) {
    return response;
  },
  function (error) {
    if (error.response.status === 500) {
      Notification['error']({
        message: `Ошибка`,
        description:
          'Во время выполнения запроса произошла непредвиденная ошибка.',
        placement: 'bottomRight',
      });
    } else {
      store.commit('app/set_http_error', error.response.data.code);
      if (error.response.data.code === 2) {
        localStorage.removeItem('token');
        router.push({ name: 'login-page' });
      }
    }
    return Promise.reject(error);
  }
);

export const Axios = {
  install: (Vue) => {
    store.$axios = axios;
    Vue.prototype.$axios = axios;
  },
};
