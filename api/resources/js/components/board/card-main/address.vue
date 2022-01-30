<template>
  <div class="card-address">
    <a-form layout="vertical">
      <a-row :gutter="[8, 0]">
        <a-col :lg="18">
          <a-form-item class="oy-form-item" label="Улица">
            <a-input size="small" :value="address.street" />
          </a-form-item>
        </a-col>
        <a-col :lg="6">
          <a-form-item class="oy-form-item" label="Номер дома">
            <a-input size="small" :value="address.street_num" />
          </a-form-item>
        </a-col>
      </a-row>
      <a-row :gutter="[8, 0]">
        <a-col :lg="4">
          <a-form-item class="oy-form-item" label="Корпус">
            <a-input size="small" :value="address.building" />
          </a-form-item>
        </a-col>
        <a-col :lg="4">
          <a-form-item class="oy-form-item" label="Литера">
            <a-input size="small" :value="address.litera" />
          </a-form-item>
        </a-col>
        <a-col :lg="4">
          <a-form-item class="oy-form-item" label="Этаж">
            <a-input size="small" :value="address.floor" />
          </a-form-item>
        </a-col>
        <a-col :lg="4">
          <a-form-item class="oy-form-item" label="Офис">
            <a-input size="small" :value="address.office" />
          </a-form-item>
        </a-col>
        <a-col :lg="8">
          <a-form-item class="oy-form-item" label="Тип помещения">
            <a-select default-value="1" size="small">
              <a-select-option value="1">
                Option 1
              </a-select-option>
              <a-select-option value="2">
                Option 2
              </a-select-option>
              <a-select-option value="3">
                Option 3
              </a-select-option>
            </a-select>
          </a-form-item>
        </a-col>
      </a-row>
    </a-form>
  </div>
</template>

<script>
import { Row, Col, Input, Form, Select } from 'ant-design-vue';

export default {
  props: {
    address: {
      type: Object,
      required: true,
    },
  },
  components: {
    'a-row': Row,
    'a-col': Col,
    'a-input': Input,
    'a-form': Form,
    'a-form-item': Form.Item,
    'a-select': Select,
    'a-select-option': Select.Option,
  },
};
</script>

<style lang="scss">
.card-address {
  font-size: 13px;
  @import 'resources/js/assets/oy-form-item';
}
</style>
