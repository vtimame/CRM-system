<template>
  <div>
    <a-textarea :value="description" auto-size></a-textarea>
  </div>
</template>

<script>
import { Form, Input } from 'ant-design-vue';

export default {
  props: {
    description: {
      type: String,
      required: true,
    },
  },
  components: {
    'a-textarea': Input.TextArea,
  },
};
</script>
