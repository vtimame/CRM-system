<template>
  <div class="card-contacts">
    <div v-for="contact in contacts" :key="contact.id" class="card-contact">
      <div class="card-contact__meta">
        <div class="card-contact__meta-name">
          {{ contact.surname }} {{ contact.name }} {{ contact.patronymic }}
        </div>
        <div class="card-contact__meta-position">{{ contact.position }}</div>
      </div>
      <div class="card-contact__phones">
        <div v-for="item in contact.phones" :key="item.id">
          {{ item.phone }}
        </div>
      </div>
      <div class="card-contact__actions">
        <a-dropdown :trigger="['click']" placement="bottomRight">
          <a-icon type="more" :style="{ fontSize: '16px' }" />
          <a-menu slot="overlay">
            <a-menu-item>Изменить</a-menu-item>
            <a-menu-item>Удалить</a-menu-item>
          </a-menu>
        </a-dropdown>
      </div>
    </div>
  </div>
</template>

<script>
import { Dropdown, Menu, Icon } from 'ant-design-vue';

export default {
  props: {
    contacts: {
      type: Array,
      required: true,
    },
  },
  components: {
    'a-dropdown': Dropdown,
    'a-menu': Menu,
    'a-menu-item': Menu.Item,
    'a-icon': Icon,
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';

.card-contacts {
  font-size: 13px;
  border-radius: 3px;
  background-color: $oc-gray-0;
}

.card-contact {
  padding: 0.3rem 0.3rem 0.3rem 1rem;
  border-bottom: 1px solid $oc-gray-1;
  display: flex;
  align-items: flex-start;

  &__meta {
    &-name {
      font-weight: 600;
      color: $oc-green-7;
    }

    &-position {
      font-size: 12px;
      line-height: 12px;
    }
  }

  &__phones {
    flex: 1;
    display: flex;
    justify-content: flex-end;
    padding-right: 1rem;
  }

  &:last-child {
    border-bottom: none;
  }
}
</style>
