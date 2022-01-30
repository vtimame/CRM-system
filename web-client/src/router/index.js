import Vue from "vue";
import VueRouter from "vue-router";
import authService from "../services/authService";

import authLayout from "../layouts/authLayout";
import defaultLayout from "../layouts/defaultLayout.vue";
import loginPage from "../pages/loginPage";
import dashboardPage from "../pages/dashboardPage.vue";
import boardPage from "../pages/boardPage.vue";

import NotFoundPage from "../pages/404.vue";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    redirect: { name: "login-page" },
    component: defaultLayout,
    meta: {
      auth: true
    },
    children: [
      {
        path: "dashboard",
        name: "dashboard-page",
        component: dashboardPage
      },
      {
        path: "board/:board_id",
        name: "board-page",
        component: boardPage
      },
      {
        path: "users",
        name: "users-page",
        component: () =>
          import(
            /* webpackChunkName: "users-page" */ "../pages/settings/users.vue"
          )
      },
      {
        path: "changelog",
        name: "changelog-page",
        component: () =>
          import(
            /* webpackChunkName: "changelog-page" */ "../pages/changelogPage.vue"
          )
      },
      {
        path: "phonebook",
        name: "phonebook-page",
        component: () =>
          import(
            /* webpackChunkName: "phonebook-page" */ "../pages/phonebook.vue"
          )
      },
      {
        path: "stats/sales-funnel",
        name: "sales-funnel-page",
        component: () =>
          import(
            /* webpackChunkName: "sales-funnel-page" */ "../pages/stats/salesFunnelPage.vue"
          )
      },
      {
        path: "stats/service",
        name: "services-stats-page",
        component: () =>
          import(
            /* webpackChunkName: "services-stats-page" */ "../pages/stats/servicesPage.vue"
          )
      },
      {
        path: "stats/manager-events",
        name: "manager-events-stats-page",
        component: () =>
          import(
            /* webpackChunkName: "manager-events-stats-page" */ "../pages/stats/managerEventsPage.vue"
          )
      },
      {
        path: "divisions",
        name: "divisions-page",
        component: () =>
          import(
            /* webpackChunkName: "divisions-page" */ "../pages/settings/divisions.vue"
          )
      },
      {
        path: "pbx",
        name: "pbx-page",
        component: () =>
          import(/* webpackChunkName: "pbx-page" */ "../pages/settings/pbx.vue")
      },
      {
        path: "site-integration",
        name: "site-integration-page",
        component: () =>
          import(
            /* webpackChunkName: "site-integration-page" */ "../pages/settings/siteIntegration.vue"
          )
      }
    ]
  },
  {
    path: "/auth",
    component: authLayout,
    meta: {
      guest: true
    },
    children: [
      {
        path: "login",
        name: "login-page",
        component: loginPage
      }
    ]
  },
  {
    path: "*",
    component: NotFoundPage,
    name: "not-found-page"
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

router.beforeEach(async (to, from, next) => {
  const jwt = localStorage.getItem("token");
  if (to.matched.some(record => record.meta.auth)) {
    if (!jwt) next({ name: "login-page" });
    else next();
  } else if (to.matched.some(record => record.meta.guest)) {
    if (jwt) next({ name: "dashboard-page" });
    else next();
  }
  next();
});

export default router;
