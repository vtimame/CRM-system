<template>
  <div class="checklists">
    <checklist
      v-for="checklist in filtered_checklists"
      :key="checklist._id"
      :checklist="checklist"
    />
  </div>
</template>

<script>
import checklist from "./checklists/checklist";

export default {
  props: {
    checklists: {
      type: Array,
      default: () => []
    }
  },
  computed: {
    user: function() {
      return this.$store.getters["user/instance"];
    },
    filtered_checklists: function() {
      let list = [];
      this.checklists.forEach(el => {
        if (el.private && this.user._id !== el.creator_id) return false;
        else list.push(el);
      });
      return list;
    }
  },
  components: {
    checklist
  }
};
</script>
