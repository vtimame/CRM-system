<template>
  <div class="card-exploring-profile">
    <!--    <exploring-section-->
    <!--      v-if="profile.user !== undefined && profile.user !== null"-->
    <!--    >-->
    <!--      <div class="d-flex align-items-center">-->
    <!--        <oy-avatar size="48" font-size="16"-->
    <!--          >{{ profile.user ? profile.user.surname[0] : ""-->
    <!--          }}{{ profile.user ? profile.user.name[0] : "" }}</oy-avatar-->
    <!--        >-->
    <!--        <div class="ml-2">-->
    <!--          <div class="card-exploring-profile__explorer-name">-->
    <!--            {{ profile.user ? profile.user.surname : "" }}-->
    <!--            {{ profile.user ? profile.user.name : "" }}-->
    <!--          </div>-->
    <!--          <div class="card-exploring-profile__created_at">-->
    <!--            {{ profile.created_at }}-->
    <!--          </div>-->
    <!--        </div>-->
    <!--      </div>-->
    <!--    </exploring-section>-->
    <exploring-section>
      <div class="row d-flex align-items-center">
        <div class="col-6">
          <span>Управляющая компания</span>
        </div>
        <div class="col-6">
          <oy-input
            :disabled="disabled"
            :value="YK"
            @change="onChange({ value: $event, key: 'YK' })"
          />
        </div>
      </div>
      <div class="row mt-2 d-flex align-items-center">
        <div class="col-6">
          <span>Как вести кабель по помещению</span>
        </div>
        <div class="col-6">
          <oy-input
            :disabled="disabled"
            :value="how_to_lead"
            @change="onChange({ value: $event, key: 'how_to_lead' })"
          />
        </div>
      </div>
      <div class="row mt-2 d-flex align-items-center">
        <div class="col-6">
          <span>Как размещаем оборудование</span>
        </div>
        <div class="col-6">
          <oy-input
            :disabled="disabled"
            :value="how_to_post"
            @change="onChange({ value: $event, key: 'how_to_post' })"
          />
        </div>
      </div>
      <div class="row mt-2 d-flex align-items-center">
        <div class="col-6">
          <span>Ограничения по времени работ</span>
        </div>
        <div class="col-6">
          <oy-input
            :disabled="disabled"
            :value="time_limit"
            @change="onChange({ value: $event, key: 'time_limit' })"
          />
        </div>
      </div>
    </exploring-section>
    <exploring-section>
      <div class="row">
        <div class="col-6">
          <div>Крыша</div>
          <oy-select
            :value="roof"
            :disabled="disabled"
            @change="onChange({ value: $event, key: 'roof' })"
          >
            <option
              v-for="option in roof_types"
              :key="option.value"
              :value="option.value"
              :selected="option.value === roof"
              >{{ option.label }}</option
            >
          </oy-select>
        </div>
        <div class="col-6">
          <div>Трасса завода кабеля</div>
          <oy-select
            :disabled="disabled"
            :value="track"
            @change="onChange({ value: $event, key: 'track' })"
          >
            <option
              v-for="option in track_types"
              :key="option.value"
              :value="option.value"
              :selected="option.value === track"
              >{{ option.label }}</option
            >
          </oy-select>
        </div>
      </div>

      <div class="row mt-2">
        <div class="col-6">
          <div>Вход в помещение</div>
          <oy-select
            :disabled="disabled"
            :value="entrance"
            @change="onChange({ value: $event, key: 'entrance' })"
          >
            <option
              v-for="option in entrance_types"
              :key="option.value"
              :value="option.value"
              :selected="option.value === entrance"
              >{{ option.label }}</option
            >
          </oy-select>
        </div>
        <div v-if="entrance === 'other'" class="col-6">
          <div>Вход в помещение (иное)</div>
          <oy-input
            :disabled="disabled"
            :value="entrance_other"
            @change="onChange({ value: $event, key: 'entrance_other' })"
          />
        </div>
      </div>

      <div class="row mt-2">
        <div class="col-6">
          <div>Окна</div>
          <oy-select
            :disabled="disabled"
            :value="window"
            @change="onChange({ value: $event, key: 'window' })"
          >
            <option
              v-for="option in window_types"
              :key="option.value"
              :value="option.value"
              :selected="option.value === window"
              >{{ option.label }}</option
            >
          </oy-select>
        </div>
        <div v-if="window === 'other'" class="col-6">
          <div>Окна (иное)</div>
          <oy-input
            :disabled="disabled"
            :value="window_other"
            @change="onChange({ value: $event, key: 'window_other' })"
          />
        </div>
      </div>

      <div class="row mt-2">
        <div class="col-6">
          <div>Точка завода кабеля</div>
          <oy-select
            :disabled="disabled"
            :value="point"
            @change="onChange({ value: $event, key: 'point' })"
          >
            <option
              v-for="option in point_types"
              :key="option.value"
              :value="option.value"
              :selected="option.value === point"
              >{{ option.label }}</option
            >
          </oy-select>
        </div>
        <div v-if="point === 'other'" class="col-6">
          <div>Точка завода кабеля (иное)</div>
          <oy-input
            :disabled="disabled"
            :value="point_other"
            @change="onChange({ value: $event, key: 'point_other' })"
          />
        </div>
      </div>
    </exploring-section>
    <exploring-section>
      <div class="row">
        <div class="col-12">
          <oy-checkbox
            :disabled="disabled"
            :value="_220V"
            @input="onChange({ value: $event, key: '_220V' })"
            >220V в месте размещения</oy-checkbox
          >
        </div>
        <div class="col-12 mt-2">
          <oy-checkbox
            :disabled="disabled"
            :value="project_for_approval"
            @input="onChange({ value: $event, key: 'project_for_approval' })"
            >Требуется проект согласования</oy-checkbox
          >
        </div>
        <div class="col-12 mt-2">
          <oy-checkbox
            :disabled="disabled"
            :value="employee_lists"
            @input="onChange({ value: $event, key: 'employee_lists' })"
            >Требуются списки работников</oy-checkbox
          >
        </div>
        <div class="col-12 mt-2">
          <oy-checkbox
            :disabled="disabled"
            :value="guarantee_letters"
            @input="onChange({ value: $event, key: 'guarantee_letters' })"
            >Требуется гарантийные письма</oy-checkbox
          >
        </div>
        <div class="col-12 mt-2">
          <oy-checkbox
            :disabled="disabled"
            :value="room_plan"
            @input="onChange({ value: $event, key: 'room_plan' })"
            >План помещения</oy-checkbox
          >
        </div>
      </div>
    </exploring-section>
  </div>
</template>

<script>
import profileMixin from "./exploring-profile/profileMixin";
import exploringSection from "./manager-profile/section.vue";

export default {
  mixins: [profileMixin],
  props: {
    profile: {
      // type: [Object, Array, null]
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  components: {
    exploringSection
  }
};
</script>

<style lang="scss">
@import "~open-color/open-color";

.card-exploring-profile {
  background-color: $oc-gray-1;
  border-radius: 3px;
  color: $oc-gray-8;
  margin-top: 0.3rem;

  &__explorer-name {
    font-weight: 600;
    line-height: 13px;
  }

  &__created_at {
    font-size: 12px;
  }
}
</style>
