<template>
  <div class="not-found-page">
    <div class="d-flex align-items-center">
      <div class="mr-3">
        <img :src="horseIcon" width="64" height="64" />
      </div>
      <div>
        <div class="title">Страница не найдена</div>
        <div class="description">
          Возможно у вас нет прав на просмотр этой страницы
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import horseIcon from "../assets/images/horse.svg";

export default {
  data: () => ({
    horseIcon: horseIcon
  })
};
</script>

<style lang="scss" scoped>
.not-found-page {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;

  .title {
    font-weight: 600;
    font-size: 1.2rem;
    line-height: 1.2rem;
  }
}
</style>
