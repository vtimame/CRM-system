export default {
  methods: {
    can(name) {
      return this.$permissions.canInColumn(
        this.user.permissions,
        name,
        this.card.board_id,
        this.card.column_id
      );
    }
  }
};
