<template>
  <div class="event">
    <div>
      <oy-avatar :data="initiator" />
    </div>
    <div class="ml-2 flex-grow-1">
      <component :is="event.type" :event="event" />
    </div>
  </div>
</template>

<script>
import cardAttachmentWasRemoved from "./events/cardAttachmentWasRemoved.vue";
import cardAttachmentWasUploaded from "./events/cardAttachmentWasUploaded.vue";
import cardCommentWasEdited from "./events/cardCommentWasEdited.vue";
import cardLeadWasAssign from "./events/cardLeadWasAssign.vue";
import cardMemberWasAdded from "./events/cardMemberWasAdded.vue";
import cardMemberWasRemoved from "./events/cardMemberWasRemoved.vue";
import cardWasMoved from "./events/cardWasMoved.vue";
import cardCommentWasAdded from "./events/cardCommentWasAdded";
import cardAnswerWasAdded from "./events/cardAnswerWasAdded";
import cardMentionWasAdded from "./events/cardMentionWasAdded";
import cardContactWasAdded from "./events/cardContactWasAdded";

import eventMixin from "./events/eventMixin";

export default {
  mixins: [eventMixin],
  props: {
    event: {
      type: Object,
      required: true
    }
  },
  computed: {
    initiator: function() {
      return this.$store.getters["users/instance"](this.event.initiator_id);
    }
  },
  components: {
    cardAttachmentWasRemoved,
    cardAttachmentWasUploaded,
    cardCommentWasEdited,
    cardLeadWasAssign,
    cardMemberWasAdded,
    cardMemberWasRemoved,
    cardWasMoved,
    cardCommentWasAdded,
    cardAnswerWasAdded,
    cardMentionWasAdded,
    cardContactWasAdded
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
.event {
  border: 1px solid $oc-gray-3;
  margin-bottom: 0.5rem;
  display: flex;
  padding: 0.5rem;

  &__initiator-name {
    font-weight: 600;
  }
}
</style>
