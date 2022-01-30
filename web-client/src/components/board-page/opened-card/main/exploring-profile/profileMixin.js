export default {
  computed: {
    YK: function() {
      return this.profile?.YK;
    },
    room_plan: function() {
      return this.profile?.room_plan;
    },
    roof: function() {
      return this.profile?.roof;
    },
    entrance: function() {
      return this.profile?.entrance;
    },
    entrance_other: function() {
      return this.profile?.entrance_other;
    },
    window: function() {
      return this.profile?.window;
    },
    window_other: function() {
      return this.profile?.window_other;
    },
    track: function() {
      return this.profile?.track;
    },
    point: function() {
      return this.profile?.point;
    },
    how_to_lead: function() {
      return this.profile?.how_to_lead;
    },
    how_to_post: function() {
      return this.profile?.how_to_post;
    },
    time_limit: function() {
      return this.profile?.time_limit;
    },
    _220V: function() {
      return this.profile?._220V;
    },
    project_for_approval: function() {
      return this.profile?.project_for_approval;
    },
    employee_lists: function() {
      return this.profile?.employee_lists;
    },
    guarantee_letters: function() {
      return this.profile?.guarantee_letters;
    }
  },
  data: () => ({
    roof_types: [
      { value: "slant", label: "Наклонная" },
      { value: "flat", label: "Плоская" },
      { value: "attic", label: "Мансарда" }
    ],
    track_types: [
      { value: "facade", label: "По фасаду" },
      { value: "mortgages", label: "По закладным" },
      { value: "staircase", label: "По лестничной клетке" }
    ],
    entrance_types: [
      { value: "facade", label: "С фасада" },
      { value: "yard", label: "Со двора" },
      { value: "other", label: "Иное" }
    ],
    window_types: [
      { value: "facade", label: "На фасад" },
      { value: "yard", label: "Во двор" },
      { value: "other", label: "Иное" }
    ],
    point_types: [
      { value: "facade", label: "С фасада" },
      { value: "yard", label: "Со двора" },
      { value: "other", label: "Иное" }
    ]
  }),
  methods: {
    onChange({ value, key }) {
      this.$emit("change", Object.assign({}, this.profile, { [key]: value }));
    }
  }
};
