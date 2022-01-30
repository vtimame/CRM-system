<template>
  <div class="services d-flex flex-column">
    <div class="services__header d-flex align-items-center">
      <div class="services__title">Звонки и встречи</div>
      <div class="services__actions d-flex align-items-center ml-3">
        <div>
          <oy-dates-range :range="datesRange" @change="onRangeChange" />
        </div>
      </div>
    </div>
    <div class="services__content flex-grow-1 pb-3">
      <table
        class="bg-white mt-3 mb-0 table table-bordered table-sm table-hover"
      >
        <tbody>
          <tr v-for="(item, index) in statsData" :key="index">
            <td>{{ item.user.surname }} {{ item.user.name }}</td>
            <td>
              <div class="row">
                <div class="col-9">
                  <div>Всего:</div>
                  <div>
                    Звонки:
                  </div>
                  <div>
                    Встречи:
                  </div>
                </div>
                <div class="col">
                  <div>{{ item.events.length }}</div>
                  <div>
                    {{
                      item.events.filter(el => el.render_type === "call").length
                    }}
                  </div>
                  <div>
                    {{
                      item.events.filter(el => el.render_type === "meeting")
                        .length
                    }}
                  </div>
                </div>
              </div>
            </td>
            <td>
              <div class="row">
                <div class="col-9">
                  <div>
                    В ожидании:
                  </div>
                  <div>
                    Звонки:
                  </div>
                  <div>
                    Встречи:
                  </div>
                </div>
                <div class="col">
                  <div>
                    {{
                      item.events.filter(el => el.status === "waiting").length
                    }}
                  </div>
                  <div>
                    {{
                      item.events.filter(
                        el =>
                          el.status === "waiting" && el.render_type === "call"
                      ).length
                    }}
                  </div>
                  <div>
                    {{
                      item.events.filter(
                        el =>
                          el.status === "waiting" &&
                          el.render_type === "meeting"
                      ).length
                    }}
                  </div>
                </div>
              </div>
            </td>
            <td>
              <div class="row">
                <div class="col-9">
                  <div>
                    Выполнено:
                  </div>
                  <div>
                    Звонки:
                  </div>
                  <div>
                    Встречи:
                  </div>
                </div>
                <div class="col">
                  <div>
                    {{
                      item.events.filter(el => el.status === "resolve").length
                    }}
                  </div>
                  <div>
                    {{
                      item.events.filter(
                        el =>
                          el.status === "resolve" && el.render_type === "call"
                      ).length
                    }}
                  </div>
                  <div>
                    {{
                      item.events.filter(
                        el =>
                          el.status === "resolve" &&
                          el.render_type === "meeting"
                      ).length
                    }}
                  </div>
                </div>
              </div>
            </td>
            <td>
              <div class="row">
                <div class="col-9">
                  <div>
                    Отклонено:
                  </div>
                  <div>
                    Звонки:
                  </div>
                  <div>
                    Встречи:
                  </div>
                </div>
                <div class="col">
                  <div>
                    {{
                      item.events.filter(el => el.status === "reject").length
                    }}
                  </div>
                  <div>
                    {{
                      item.events.filter(
                        el =>
                          el.status === "reject" && el.render_type === "call"
                      ).length
                    }}
                  </div>
                  <div>
                    {{
                      item.events.filter(
                        el =>
                          el.status === "reject" && el.render_type === "meeting"
                      ).length
                    }}
                  </div>
                </div>
              </div>
            </td>
            <td>
              <div class="row">
                <div class="col-9">
                  <div>Просрочено:</div>
                  <div>
                    Звонки:
                  </div>
                  <div>
                    Встречи:
                  </div>
                </div>
                <div class="col">
                  <div>{{ getExpiredEvents(item.events).length }}</div>
                  <div>
                    {{
                      getExpiredEvents(item.events).filter(
                        el => el.render_type === "call"
                      ).length
                    }}
                  </div>
                  <div>
                    {{
                      getExpiredEvents(item.events).filter(
                        el => el.render_type === "meeting"
                      ).length
                    }}
                  </div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <td>Общее количество</td>
            <td>
              <div class="d-flex justify-content-between">
                <div>Всего:</div>
                <div class="pr-2">{{ allEvents.length }}</div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Звонки:</div>
                <div class="pr-2">
                  {{ allEvents.filter(el => el.render_type === "call").length }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Встречи:</div>
                <div class="pr-2">
                  {{
                    allEvents.filter(el => el.render_type === "meeting").length
                  }}
                </div>
              </div>
            </td>
            <td>
              <div class="d-flex justify-content-between">
                <div>В ожидании:</div>
                <div class="pr-2">
                  {{ allEvents.filter(el => el.status === "waiting").length }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Всего:</div>
                <div class="pr-2">
                  {{
                    allEvents.filter(
                      el => el.status === "waiting" && el.render_type === "call"
                    ).length
                  }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Всего:</div>
                <div class="pr-2">
                  {{
                    allEvents.filter(
                      el =>
                        el.status === "waiting" && el.render_type === "meeting"
                    ).length
                  }}
                </div>
              </div>
            </td>
            <td>
              <div class="d-flex justify-content-between">
                <div>Выполнено:</div>
                <div class="pr-2">
                  {{ allEvents.filter(el => el.status === "resolve").length }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Всего:</div>
                <div class="pr-2">
                  {{
                    allEvents.filter(
                      el => el.status === "resolve" && el.render_type === "call"
                    ).length
                  }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Всего:</div>
                <div class="pr-2">
                  {{
                    allEvents.filter(
                      el =>
                        el.status === "resolve" && el.render_type === "meeting"
                    ).length
                  }}
                </div>
              </div>
            </td>
            <td>
              <div class="d-flex justify-content-between">
                <div>Выполнено:</div>
                <div class="pr-2">
                  {{ allEvents.filter(el => el.status === "reject").length }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Всего:</div>
                <div class="pr-2">
                  {{
                    allEvents.filter(
                      el => el.status === "reject" && el.render_type === "call"
                    ).length
                  }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Всего:</div>
                <div class="pr-2">
                  {{
                    allEvents.filter(
                      el =>
                        el.status === "reject" && el.render_type === "meeting"
                    ).length
                  }}
                </div>
              </div>
            </td>
            <td>
              <div class="d-flex justify-content-between">
                <div>Просрочено:</div>
                <div class="pr-2">{{ getAllExpiredEvents.length }}</div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Звонки:</div>
                <div class="pr-2">
                  {{
                    getAllExpiredEvents.filter(el => el.render_type === "call")
                      .length
                  }}
                </div>
              </div>
              <div class="d-flex justify-content-between">
                <div>Встречи:</div>
                <div class="pr-2">
                  {{
                    getAllExpiredEvents.filter(
                      el => el.render_type === "meeting"
                    ).length
                  }}
                </div>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import flatten from "lodash/flatten";

export default {
  name: "manager-events-stats-page",
  async mounted() {
    if (!this.systemScopeHas("view_manager_events_stats")) {
      await this.$router.push({ name: "not-found-page" });
    }

    const date = new Date(),
      y = date.getFullYear(),
      m = date.getMonth();
    const start = new Date(y, m, 1);
    const end = new Date(y, m + 1, 0);

    this.datesRange = { start, end };
    await this.loadStats();
  },
  data: () => ({
    datesRange: null
  }),
  computed: {
    events: function() {
      return this.$store.getters["app/stats/managerEvents/list"];
    },
    statsData: function() {
      const list = [];
      this.events.map(event => {
        const index = list.findIndex(el => el.user._id === event.user._id);
        if (index !== -1) {
          list[index].events.push(event);
        } else {
          list.push({ user: event.user, events: [event] });
        }
      });
      return list;
    },
    allEvents: function() {
      return flatten(this.statsData.map(el => el.events));
    },
    getAllExpiredEvents: function() {
      return this.allEvents.filter(
        event =>
          moment(event.event_dt).unix() < moment().unix() &&
          event.status === "waiting"
      );
    }
  },
  methods: {
    getExpiredEvents(events) {
      return events.filter(
        event =>
          moment(event.event_dt).unix() < moment().unix() &&
          event.status === "waiting"
      );
    },
    async loadStats() {
      await this.$store.dispatch(
        "app/stats/managerEvents/loadEvents",
        this.datesRange
      );
    },
    async onRangeChange(range) {
      this.datesRange = range;
      await this.loadStats();
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.services {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 12px;
  overflow-y: auto;
  @include scrollbars(4px, $oc-gray-5, $oc-gray-3);

  &__title {
    font-weight: 600;
    font-size: 1.2rem;
  }
}
</style>
