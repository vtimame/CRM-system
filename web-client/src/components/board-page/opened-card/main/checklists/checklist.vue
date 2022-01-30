<template>
  <div class="checklist">
    <div class="d-flex justify-content-between">
      <div class="d-flex align-items-center">
        <div class="mr-2" v-if="!editMode">
          <oy-avatar :data="getUserInstance(checklist.creator_id)" size="24" />
        </div>
        <div class="checklist__title" v-if="!editMode">
          {{ checklist.title }}
        </div>
        <div v-else class="d-flex align-items-center">
          <oy-input
            :value="checklist.title"
            @change="onTitleChange($event)"
            ref="title"
            :input-style="{
              fontWeight: 600,
              fontSize: '11px',
              paddingTop: 0,
              paddingBottom: 0
            }"
          />
          <oy-checkbox
            checkbox-position="left"
            class="ml-3"
            :value="isPrivate"
            @input="onPrivateChange($event)"
            >Приватный чек-лист</oy-checkbox
          >
        </div>
      </div>
      <div v-if="!editMode && checklist.creator_id === user._id">
        <oy-feather-icon
          type="edit"
          size="16"
          :style="{ cursor: 'pointer' }"
          @click="setEditMode"
        />
      </div>
      <div v-if="editMode && checklist.creator_id === user._id">
        <oy-feather-icon
          type="check"
          size="16"
          :style="{ cursor: 'pointer' }"
          @click="editMode = false"
        />
      </div>
    </div>
    <div v-if="checklist.points.length > 0" class="d-flex align-items-center">
      <div>{{ progressIndicatorLength }}%</div>
      <div class="checklist__progress flex-grow-1 ml-2">
        <div
          class="checklist__progress-indicator"
          :class="{
            'checklist__progress-indicator--closed': checkListIsClosed
          }"
          :style="{ width: `${progressIndicatorLength}%` }"
        ></div>
      </div>
    </div>
    <div class="checklist__body">
      <div
        v-if="checklist.points.length === 0"
        class="py-2 px-3 d-flex justify-content-center"
        :style="{ fontWeight: 600 }"
      >
        Здесь пока нет ни одного пункта
      </div>
      <div v-else>
        <div
          class="checklist__point d-flex justify-content-between align-items-center"
          v-for="(point, index) in checklist.points"
          :key="index"
        >
          <div class="d-flex align-items-center" :style="{ flex: 1 }">
            <oy-checkbox
              v-if="!editMode"
              :disabled="checkboxDisabled(point)"
              checkbox-position="left"
              :value="isClosed(point)"
              @input="onPointChange(index, $event)"
            >
              <div>{{ point.title }}</div>
            </oy-checkbox>
            <div
              v-else
              class="d-flex align-items-center justify-content-between"
              :style="{ flex: 1 }"
            >
              <oy-input
                class="mr-2"
                :value="point.title"
                @change="onPointTitleChange(index, $event)"
                :input-style="{
                  fontWeight: 600,
                  fontSize: '11px',
                  paddingTop: 0,
                  paddingBottom: 0
                }"
              />
              <div class="d-flex align-items-center">
                <div>
                  {{ formatExecutionDate(point.execution_at) }}
                </div>
                <div
                  :style="{ width: '32px', height: '32px' }"
                  class="d-flex justify-content-center align-items-center"
                >
                  <checklist-datepicker
                    :date="point.execution_at"
                    @change="onPointDateChange(index, $event)"
                  />
                </div>
              </div>
            </div>
          </div>
          <div class="d-flex align-items-center">
            <div
              v-if="!editMode"
              class="mr-2"
              :class="{
                'checklist__point-isExpired':
                  !isClosed(point.closed_at) && isExpired(point.execution_at)
              }"
            >
              {{ formatExecutionDate(point.execution_at) }}
            </div>
            <div class="d-flex responsible__users justify-content-end">
              <div @click="editResponsibleUsers(index)" class="d-flex">
                <div v-for="(user_id, i) in point.responsible" :key="i">
                  <oy-avatar
                    class="checklist__responsible-avatar"
                    :data="getUserInstance(user_id)"
                    size="22"
                  />
                </div>
                <oy-circle-button
                  class="checklist__responsible-avatar"
                  v-if="editMode"
                  size="22"
                  @click="editResponsibleUsers(index)"
                >
                  <oy-feather-icon type="plus" size="14" />
                </oy-circle-button>
              </div>
            </div>
            <oy-feather-icon
              v-if="editMode"
              class="ml-2"
              type="x"
              size="14"
              @click="onPointDelete(index)"
            />
          </div>
        </div>
      </div>
      <div v-if="editMode" class="checklist__point d-flex align-items-center">
        <oy-circle-button size="26" @click="addNewPoint">
          <oy-feather-icon type="plus" size="16" />
        </oy-circle-button>
        <div class="ml-2">Добавить еще один пункт...</div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from "moment";
import checklistDatepicker from "./datepicker.vue";

export default {
  props: {
    checklist: {
      type: Object
    }
  },
  data: () => ({
    editMode: false,
    point_date: null,
    new_points: []
  }),
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    isPrivate: function() {
      if (!this.checklist.private) return Boolean(0);
      else return this.checklist.private;
    },
    closedPoints: function() {
      return this.checklist.points.filter(el => el.closed_at).length;
    },
    progressIndicatorLength: function() {
      if (this.checklist.points.length === 0) return 0;
      return (100 / this.checklist.points.length) * this.closedPoints;
    },
    checkListIsClosed: function() {
      return this.checklist.points.filter(el => !el.closed_at).length === 0;
    }
  },
  methods: {
    checkboxDisabled(point) {
      if (this.checklist.creator_id === this.user._id) return Boolean(0);
      else return !this.userInResponsibleList(point);
    },
    userInResponsibleList(point) {
      if (!point.responsible) return Boolean(0);
      return point.responsible.find(el => el === this.user._id) !== undefined;
    },
    async onPointChange(index, value) {
      const checklist = Object.assign({}, this.checklist);
      if (value === true) {
        checklist.points[index].closed_at = moment();
      } else delete checklist.points[index].closed_at;
      await this.updateChecklist(checklist);
    },
    formatExecutionDate(date) {
      if (!date) return "";
      return moment(date).format("DD.MM.YYYY HH:mm");
    },
    async onPointDateChange(index, value) {
      const checklist = Object.assign({}, this.checklist);
      checklist.points[index].execution_at = value;
      await this.updateChecklist(checklist);
    },
    getUserInstance(id) {
      return this.$store.getters["users/instance"](id);
    },
    isExpired(date) {
      const now = moment().unix();
      const executeDate = moment(date).unix();
      return now > executeDate;
    },
    isClosed(point) {
      if (!point) return Boolean(0);
      return point.closed_at !== undefined;
    },
    setEditMode() {
      this.editMode = true;
      setTimeout(() => {
        this.$refs.title.focus();
      }, 10);
    },
    async updateChecklist(checklist) {
      await this.$store.dispatch(
        "kanban/card/checklists/updateChecklist",
        checklist
      );
    },
    async addNewPoint() {
      const checklist = Object.assign({}, this.checklist);
      checklist.points.push({ title: "Новый пункт" });
      await this.updateChecklist(checklist);
    },
    async onTitleChange(value) {
      const checklist = Object.assign({}, this.checklist);
      checklist.title = value;
      await this.updateChecklist(checklist);
    },
    async onPrivateChange(value) {
      const checklist = Object.assign({}, this.checklist);
      checklist.private = value;
      await this.updateChecklist(checklist);
    },
    async onPointTitleChange(index, value) {
      const checklist = Object.assign({}, this.checklist);
      checklist.points[index].title = value;
      await this.updateChecklist(checklist);
    },
    async onPointDelete(index) {
      const checklist = Object.assign({}, this.checklist);
      checklist.points.splice(index, 1);
      await this.updateChecklist(checklist);
    },
    editResponsibleUsers(index) {
      if (this.editMode) {
        this.$modal.open({
          name: "checklist-responsible-users",
          position: "center",
          width: "650",
          point_index: index,
          checklist: this.checklist
        });
      }
    }
  },
  components: {
    checklistDatepicker
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.checklist {
  padding: 0.5rem 1rem;

  .mx-input-wrapper,
  .mx-datepicker {
    width: auto;
  }

  .mx-input {
    height: 27px;
    border-radius: 3px;
    font-size: 11px;
    width: auto;
    display: none;
  }

  .mx-icon-clear,
  .mx-icon-calendar {
    margin-right: -15px;
  }

  &__title {
    font-size: 1rem;
    font-weight: 600;
  }

  &__progress {
    height: 7px;
    background-color: $oc-gray-2;
    border-radius: 1px;

    &-indicator {
      height: 7px;
      background-color: $oc-blue-5;
      transition: 0.25s;

      &--closed {
        background-color: $oc-green-5;
      }
    }
  }

  &__body {
    margin-top: 0.3rem;
    background-color: $oc-gray-1;
    border-radius: 3px;
  }

  &__point {
    padding: 0.5rem 1rem;
    border-bottom: 1px solid $oc-gray-2;
    cursor: pointer;
    transition: 0.2s;

    &:hover {
      background-color: $oc-gray-2;
    }

    &:last-child {
      margin-bottom: 0;
      border-bottom: none;
    }

    &-title {
      font-size: 12px;
      line-height: 12px;
    }

    &-isExpired {
      color: $oc-red-5;
    }
  }

  .responsible__users {
    min-width: 7rem;
  }

  &__responsible-avatar {
    border: 1px solid $oc-violet-1;
    margin-left: -5px;
  }
}
</style>
