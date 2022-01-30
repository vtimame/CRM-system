<template>
  <div class="search-bar">
    <input
      type="text"
      class="search-bar__input w-100"
      placeholder="Поиск по доске..."
      v-model="search_value"
    />
    <el-popover width="200" trigger="hover" content="Тестовая фича">
      <oy-feather-icon
        type="help-circle"
        size="18"
        :stroke="$oc.gray[8]"
        class="help-icon"
        slot="reference"
      />
    </el-popover>
  </div>
</template>

<script>
import { Popover } from "element-ui";
import "element-ui/lib/theme-chalk/popover.css";

export default {
  computed: {
    search_value: {
      get: function() {
        return this.$store.getters["kanban/cards/search_value"];
      },
      set: function(value) {
        this.$store.commit("kanban/cards/setSearchValue", value);
      }
    }
  },
  components: {
    "el-popover": Popover
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";

.search-bar {
  position: relative;

  &__input {
    border: none;
    outline: none;
    font-size: 13px;
    font-weight: 600;
    padding: 0.3rem 1rem;
    background-color: $oc-gray-2;
    border-radius: 3px;
    color: $oc-gray-8;
    width: 280px;
  }

  .help-icon {
    position: absolute;
    right: 0.4rem;
    top: 0.4rem;
    cursor: pointer;
  }
}
</style>
