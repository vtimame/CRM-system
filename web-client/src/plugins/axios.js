import Vue from "vue";
// import https from "https";
import axios from "axios";
import store from "../store";
import router from "../router";

// axios.defaults.httpsAgent = new https.Agent({
//   rejectUnauthorized: false
// });

axios.defaults.baseURL = process.env.VUE_APP_API_URL;

axios.interceptors.request.use(
  config => {
    store.commit("app/clearHttpError");
    store.commit("app/clearValidateErrors");

    const jwt = store.getters["user/token"];
    if (jwt !== null) {
      config.headers["Authorization"] = `Bearer ${jwt}`;
    }

    return config;
  },
  error => {
    return Promise.reject(error);
  }
);
axios.interceptors.response.use(
  config => {
    return config;
  },
  error => {
    if (!error.response || !error.response.status) {
      console.log(error);
    }
    if (error.response.status === 422) {
      Object.keys(error.response.data).forEach(key => {
        const message =
          typeof error.response.data === "object"
            ? error.response.data[key][0]
            : error.response.data[key];
        store.commit("app/pushValidateError", { key, message });
      });
    }

    if (error.response.status === 401) {
      localStorage.removeItem("token");
      router.push({ name: "login-page" });
    }

    if (error.response.data.code !== undefined) {
      store.commit("app/setHttpErrorCode", error.response.data.code);
    }

    return Promise.reject(error);
  }
);

export default {
  install: Vue => {
    Vue.prototype.$axios = axios;
  }
};
