<template>
  <div class="not-found">
    <a-col :lg="8">
      <a-result
        status="error"
        title="Страница не найдена"
        sub-title="Запрашиваемый вами ресурс не доступен."
      >
        <template #extra>
          <a-button @click="$router.push({ name: 'login-page' })">
            Вернуться на рабочий стол
          </a-button>
        </template>
      </a-result>
    </a-col>
  </div>
</template>
<script>
import { Result, Icon, Button, Col } from 'ant-design-vue';

export default {
  components: {
    'a-result': Result,
    'a-icon': Icon,
    'a-button': Button,
    'a-col': Col,
  },
};
</script>
<style lang="scss" scoped>
.not-found {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
}
</style>
