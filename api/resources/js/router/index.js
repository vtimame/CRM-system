import Vue from 'vue';
import VueRouter from 'vue-router';
import defaultLayout from '../layouts/default.vue';

Vue.use(VueRouter);

const router = new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/',
      redirect: { name: 'login-page' },
      component: defaultLayout,
      children: [
        {
          path: '/dashboard',
          name: 'dashboard-page',
          meta: {
            auth: true,
          },
          component: () =>
            import(
              /* webpackChunkName: "dashboard-page" */ '../views/DashboardView.vue'
            ),
        },
        {
          path: '/board/:board_id',
          name: 'board-page',
          meta: {
            auth: true,
          },
          component: () =>
            import(
              /* webpackChunkName: "board-page" */ '../views/BoardView.vue'
            ),
        },
        {
          path: '/control/employees',
          name: 'control-employees-page',
          meta: {
            auth: true,
          },
          component: () =>
            import(
              /* webpackChunkName: "control-employees-page" */ '../views/control/EmployeesView.vue'
            ),
        },
        {
          path: '/control/boards',
          name: 'control-boards-page',
          meta: {
            auth: true,
          },
          component: () =>
            import(
              /* webpackChunkName: "control-boards-page" */ '../views/control/BoardsView.vue'
            ),
        },
      ],
    },
    {
      path: '/login',
      name: 'login-page',
      meta: {
        guest: true,
      },
      component: () =>
        import(/* webpackChunkName: "login-page" */ '../views/LoginView.vue'),
    },
    {
      path: '*',
      component: () =>
        import(
          /* webpackChunkName: "not-found-page" */ '../views/error/404.vue'
        ),
    },
  ],
});

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');

  if (to.matched.some((record) => record.meta.auth)) {
    if (token === null) {
      next({ name: 'login-page' });
    }
    next();
  } else if (to.matched.some((record) => record.meta.guest)) {
    if (token !== null) {
      next({ name: 'dashboard-page' });
    }
    next();
  } else next();
});

export { router };
