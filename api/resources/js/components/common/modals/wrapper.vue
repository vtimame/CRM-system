<template>
  <div
    class="modal__overlay"
    :style="{ alignItems: alignItems }"
    @mousedown="close"
  >
    <div class="modal__wrapper" :style="{ width: width }">
      <div class="modal__window">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    options: {
      type: Object,
      required: true,
    },
  },
  computed: {
    width: function () {
      const width = this.options.width;
      return width ? width : '950px';
    },
    alignItems: function () {
      const position = this.options.position ? this.options.position : 'center';
      switch (position) {
        case 'top':
          return 'flex-start';
        case 'center':
          return 'center';
        case 'bottom':
          return 'flex-end';
      }
    },
  },
  methods: {
    close(event) {
      if (event.target.closest('.btn') !== null) return false;
      if (event.target.closest('.modal__window') !== null) return false;
      this.$modal.close(this.options.name);

      if (this.options.name === 'opened-card') {
        this.$router.replace({ name: this.$route.name });
      }

      this.$emit('close');
    },
  },
};
</script>

<style lang="scss" scoped>
.modal {
  &__overlay {
    cursor: pointer;
    z-index: 100;
    background-color: rgba(0, 0, 0, 0.3);
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    justify-content: center;
    overflow-y: auto;
  }

  &__wrapper {
    cursor: pointer;
    padding: 6rem 0;
  }

  &__window {
    cursor: default;
    background-color: white;
    border-radius: 3px;
  }
}
</style>
