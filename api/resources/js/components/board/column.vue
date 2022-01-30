<template>
  <div class="column__wrapper">
    <div class="column">
      <div class="column__header">{{ column.name }}</div>
      <div v-if="!loaded" class="column__body">
        <a-card
          v-for="n in skeleton_count"
          :key="n"
          :style="{ marginBottom: '1rem' }"
          ><a-skeleton
        /></a-card>
      </div>
      <Container
        v-else
        class="column__body"
        group-name="column"
        :animation-duration="0"
      >
        <Draggable v-for="thumbnail in thumbnails" :key="thumbnail.id">
          <thumbnail :data="thumbnail" />
        </Draggable>

        <a-button
          v-if="thumbnails.length < column.thumbnails_count"
          :loading="loading_button"
          @click="onLoadingButtonClick"
          type="dashed"
          icon="plus"
          :style="{ width: '100%' }"
          >Загрузить все карточки</a-button
        >
      </Container>
      <div class="column__footer">
        <button
          class="column__footer__button"
          @click="
            $modal.open({
              name: 'new-card',
              width: '850px',
              position: 'top',
            })
          "
        >
          <div>Добавить карточку</div>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { Card, Skeleton, Button } from 'ant-design-vue';
import { Container, Draggable } from 'vue-smooth-dnd';
import Thumbnail from './thumbnail';

export default {
  props: {
    column: {
      type: Object,
      required: true,
    },
  },
  data: () => ({
    loading_button: false,
  }),
  mounted() {
    // window.addEventListener('wheel', this.wheelController, true);
  },
  beforeDestroy() {
    // window.removeEventListener('wheel', this.wheelController, true);
  },
  computed: {
    loaded: function () {
      return this.$store.getters['kanban/thumbnails/loaded'];
    },
    thumbnails: function () {
      return this.$store.getters['kanban/thumbnails/list'](this.column.id);
    },
    skeleton_count: function () {
      return this.column.thumbnails_count > 6
        ? 6
        : this.column.thumbnails_count;
    },
  },
  methods: {
    async onLoadingButtonClick() {
      this.loading_button = true;
      await this.$store.dispatch('thumbnails/loadThumbnails', this.column.id);
      this.loading_button = false;
    },
    wheelController(event) {
      console.log(event);
    },
  },
  components: {
    Thumbnail,
    Container,
    Draggable,
    'a-card': Card,
    'a-skeleton': Skeleton,
    'a-button': Button,
  },
};
</script>

<style lang="scss" scoped>
@import '~open-color/open-color';
@import 'resources/js/assets/mixins';

.column {
  display: flex;
  flex-direction: column;
  max-height: 100%;
  background-color: $oc-gray-2;
  border: 1px solid $oc-gray-3;

  &__wrapper {
    flex: 0 0 auto;
    width: 300px;
  }

  &__header {
    padding: 0.5rem 1rem;
    font-weight: 600;
    border-bottom: 1px solid $oc-gray-3;
  }

  &__body {
    flex: 1;
    overflow-x: hidden;
    overflow-y: auto;
    padding: 0.5rem 1rem;
    @include scrollbars(4px, $oc-gray-5, $oc-gray-2);
  }

  &__footer {
    border-top: 1px solid $oc-gray-3;

    &__button {
      width: 100%;
      border: none;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: $oc-gray-3;
      padding: 0.3rem 0;
      cursor: pointer;
      transition: 0.2s;
      font-weight: 600;

      &:hover {
        background-color: $oc-gray-4;
      }
    }
  }
}
</style>
