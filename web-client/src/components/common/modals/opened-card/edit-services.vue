<template>
  <wrapper :options="options">
    <div class="edit-services">
      <div class="edit-services__header">
        Добавить услугу
      </div>
      <div class="edit-services__body">
        <div
          :style="{
            padding: '0.5rem 1rem'
          }"
        >
          <oy-search-select
            :options="services"
            label="title"
            value="Выберите услугу"
            :clearable="false"
            @input="onServiceSelect"
          />
        </div>
        <div>
          <div
            v-for="(service, i) in current_services"
            :key="i"
            class="row no-gutters d-flex align-items-center mb-2 pb-2"
            :style="{
              borderBottom: `1px solid ${$oc.gray[3]}`,
              padding: '0.5rem 1rem'
            }"
          >
            <div
              class="col-3 d-flex align-items-center"
              :style="{ fontWeight: 600 }"
            >
              <oy-feather-icon
                type="trash"
                size="14"
                :style="{ cursor: 'pointer' }"
                @click="deleteService(i)"
              />
              <div class="pl-2">{{ service.title }}</div>
            </div>
            <div class="col-6 d-flex">
              <div
                v-for="(field, o) in service.fields"
                :key="o"
                :style="{ flex: 1 }"
                :class="{ 'pr-2': service.fields.length > 0 }"
              >
                <oy-input
                  :prefix="field.title"
                  v-model="field.value"
                  @keydown="onFiledInput($event, field.maxLength, field.reg)"
                  @change="onChange"
                />
              </div>
            </div>
            <div class="col-3">
              <div>
                <oy-input
                  prefix="Цена"
                  v-model="service.price"
                  @change="onChange"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </wrapper>
</template>

<script>
import modal from "../modal";
import wrapper from "../wrapper";
import cardService from "../../../../services/cardService";

export default {
  mixins: [modal],
  mounted() {
    if (this.options.card.services) {
      this.current_services = this.options.card.services;
    }
  },
  data: () => ({
    current_services: [],
    services: [
      {
        title: "Доступ в интернет",
        fields: [{ title: "Mbit/s", maxLength: 4, reg: "^[0-9]+$" }]
      },
      {
        title: "Выделенный канал",
        fields: [{ title: "Mbit/s", maxLength: 4, reg: "^[0-9]+$" }]
      },
      // {
      //   title: "Размещение сервера",
      //   fields: [
      //     { title: "U", maxLength: 1, reg: "^[0-9]+$" },
      //     { title: "Питание/Ватт", maxLength: 4, reg: "^[0-9]+$" }
      //   ]
      // },
      {
        title: "Аренда сервера",
        fields: [
          { title: "CPU", maxLength: 2, reg: "^[0-9]+$" },
          { title: "RAM", maxLength: 3, reg: "^[0-9]+$" },
          { title: "HDD", maxLength: 4, reg: "^[0-9]+$" }
        ]
      },
      {
        title: "Виртуальный сервер",
        fields: [
          { title: "CPU", maxLength: 2, reg: "^[0-9]+$" },
          { title: "RAM", maxLength: 3, reg: "^[0-9]+$" },
          { title: "HDD", maxLength: 4, reg: "^[0-9]+$" }
        ]
      },
      {
        title: "Виртуальная АТС",
        fields: [{ title: "Линий", maxLength: 2, reg: "^[0-9]+$" }]
      },
      {
        title: "FusionOffice",
        fields: [
          { title: "Mbit/s", maxLength: 3, reg: "^[0-9]+$" },
          { title: "Телефонов", maxLength: 3, reg: "^[0-9]+$" }
        ]
      },
      {
        title: "Видеонаблюдение",
        fields: [{ title: "Камер", maxLength: 2, reg: "^[0-9]+$" }]
      },
      {
        title: "IP адреса",
        fields: [{ title: "Кол-во", maxLength: 3, reg: "^[0-9\\/]+$" }]
      },
      {
        title: "IT Аутсорсинг",
        fields: [{ title: "PC", maxLength: 3, reg: "^[0-9]+$" }]
      },
      {
        title: "IPTV Hotel",
        fields: [{ title: "TV", maxLength: 2, reg: "^[0-9]+$" }]
      },
      {
        title: "IPTV Open",
        fields: [{ title: "TV", maxLength: 2, reg: "^[0-9]+$" }]
      },
      {
        title: "IPTV Office",
        fields: [{ title: "TV", maxLength: 2, reg: "^[0-9]+$" }]
      },
      {
        title: "Wifi вход по звонку",
        fields: [{ title: "AP", maxLength: 2, reg: "^[0-9]+$" }]
      },
      {
        title: "Wifi вход по паролю",
        fields: [{ title: "AP", maxLength: 2, reg: "^[0-9]+$" }]
      },
      {
        title: "ЛВС",
        fields: [{ title: "РМ (рабочие места)", maxLength: 3, reg: "^[0-9]+$" }]
      }
    ]
  }),
  methods: {
    onServiceSelect(service) {
      const data = Object.assign({ price: "" }, service);
      data.fields.forEach(el => (el.value = ""));
      this.current_services.push(data);
    },
    onFiledInput(event, maxLength, reg) {
      const regExp = new RegExp(reg);
      if (event.key === "Backspace" || event.key === "F5") return false;
      if (event.target.value.length + 1 > maxLength) event.preventDefault();
      if (!regExp.test(event.key)) event.preventDefault();
    },
    deleteService(i) {
      this.current_services.splice(i, 1);
      cardService.updateCard(this.$route.query.card_id, {
        services: this.current_services
      });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.$route.query.card_id,
        payload: { services: this.current_services }
      });
    },
    onChange() {
      cardService.updateCard(this.$route.query.card_id, {
        services: this.current_services
      });
      this.$store.commit("kanban/cards/setCardData", {
        card_id: this.$route.query.card_id,
        payload: { services: this.current_services }
      });
    }
  },
  components: {
    wrapper
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.edit-services {
  font-size: 13px;
  min-height: 450px;
  user-select: none;

  &__header {
    border-bottom: 1px solid $oc-gray-3;
    font-weight: 600;
    padding: 0.5rem 1rem;
  }
}
</style>
