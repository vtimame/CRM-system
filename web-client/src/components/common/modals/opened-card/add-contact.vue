<template>
  <wrapper :options="options">
    <div class="add-contact">
      <div class="add-contact__header">
        {{ contact._id ? "Изменить" : "Добавить" }} контакт
      </div>
      <div class="add-contact__body">
        <oy-input
          v-model="$v.contact.surname.$model"
          label="Фамилия"
          class="mb-3"
          :error="getError('surname')"
        />
        <oy-input
          v-model="$v.contact.name.$model"
          label="Имя"
          class="mb-3"
          :error="getError('name')"
        />
        <oy-input
          v-model="$v.contact.patronymic.$model"
          label="Отчество"
          class="mb-3"
          :error="getError('patronymic')"
        />
        <div class="phones pb-2">
          <div
            class="d-flex align-items-end mb-3"
            v-for="(item, i) in contact.phones"
            :key="i"
          >
            <div :style="{ flex: 7 }">
              <oy-input
                :ref="`phone${i}`"
                label="Номер телефона"
                v-model="$v.contact.phones.$each[i].phone.$model"
                prefix="+7"
                :error="getError('phones', i, 'phone')"
                :inputStyle="{
                  borderTopRightRadius: 0,
                  borderBottomRightRadius: 0
                }"
              />
            </div>
            <div :style="{ flex: 2 }">
              <oy-input
                label="Доб."
                :error="getError('phones', i, 'additional')"
                v-model="$v.contact.phones.$each[i].additional.$model"
                :inputStyle="
                  contact.phones.length > 1
                    ? {
                        borderRadius: 0
                      }
                    : { borderTopLeftRadius: 0, borderBottomLeftRadius: 0 }
                "
              />
            </div>
            <div v-if="contact.phones.length > 1">
              <button
                class="btn btn-sm btn-danger btn-block"
                @click="removePhone(i)"
                :style="{
                  borderTopLeftRadius: 0,
                  borderBottomLeftRadius: 0,
                  paddingTop: '0.28rem',
                  paddingBottom: '0.28rem'
                }"
              >
                <oy-feather-icon type="trash" size="14" />
              </button>
            </div>
          </div>
        </div>
        <div>
          <button
            class="btn btn-sm btn-outline-primary btn-block"
            @click="addPhone"
          >
            Добавить еще один номер телефона
          </button>
        </div>
        <oy-input
          v-model="$v.contact.position.$model"
          label="Должность"
          class="mb-3"
          :error="getError('position')"
        />
        <oy-input
          v-model="$v.contact.email.$model"
          label="Email"
          class="mb-3"
          :error="getError('email')"
        />
        <button class="btn btn-sm btn-block btn-success mt-4" @click="onSubmit">
          {{ contact._id ? "Изменить" : "Добавить" }}
        </button>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "../modal";
import wrapper from "../wrapper";
import { required, maxLength, email, numeric } from "vuelidate/lib/validators";
import { cyrillic } from "../../../../plugins/validation";

export default {
  mixins: [modal],
  mounted() {
    if (this.options.contact) {
      this.contact = this.options.contact;
    }
  },
  data: () => ({
    contact: {
      name: "",
      surname: "",
      patronymic: "",
      email: "",
      position: "",
      phones: [{ phone: "", additional: "" }]
    }
  }),
  validations: {
    contact: {
      name: { required, cyrillic },
      surname: { cyrillic },
      patronymic: { cyrillic },
      email: { email },
      position: {},
      phones: {
        $each: {
          phone: { required, numeric, maxLength: maxLength(10) },
          additional: { numeric }
        }
      }
    }
  },
  components: {
    wrapper
  },
  methods: {
    onSubmit() {
      this.$v.$touch();
      if (this.options.callback !== undefined && !this.$v.$error) {
        this.options.callback(this.contact);
        this.close();
      }
    },
    async addPhone() {
      await this.contact.phones.push({ phone: "", additional: "" });
    },
    removePhone(i) {
      this.contact.phones.splice(i, 1);
    },
    getError(name, index = null, subname = null) {
      const target =
        index !== null
          ? this.$v.contact[name].$each[index][subname]
          : this.$v.contact[name];

      if (target.$dirty) {
        if (target.required === false) return "Заполните это поле";
        if (target.numeric === false) return "numeric";
        if (target.cyrillic === false) return "Смените раскладку";
        if (target.email === false) return "Вы ввели не корректный e-mail";
        if (target.maxLength === false) return "Не больше 10 символов";
      }
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.add-contact {
  &__header {
    font-size: 1rem;
    font-weight: 600;
    border-bottom: 1px solid $oc-gray-3;
  }

  &__header,
  &__body {
    padding: 0.5rem 1rem;
    font-size: 13px;
  }
}
</style>
