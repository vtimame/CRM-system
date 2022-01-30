<template>
  <date-picker
    v-model="execution_date"
    placeholder="Выберите дату события"
    @change="$emit('change', $event)"
    type="datetime"
    format="DD.MM.YYYY H:mm"
    :disabled-date="notBeforeDate"
    :disabled-time="notBeforeTime"
    :lang="{
      months: [
        'январь',
        'февраль',
        'март',
        'апрель',
        'май',
        'июнь',
        'июль',
        'август',
        'сентябрь',
        'октябрь',
        'ноябрь',
        'декабрь'
      ],
      monthsShort: [
        'янв.',
        'февр.',
        'март',
        'апр.',
        'май',
        'июнь',
        'июль',
        'авг.',
        'сент.',
        'окт.',
        'нояб.',
        'дек.'
      ],
      weekdays: [
        'воскресенье',
        'понедельник',
        'вторник',
        'среда',
        'четверг',
        'пятница',
        'суббота'
      ],
      weekdaysShort: ['вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'],
      weekdaysMin: ['вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб'],
      firstDayOfWeek: 1,
      firstWeekContainsDate: 1
    }"
  ></date-picker>
</template>

<script>
import DatePicker from "vue2-datepicker";

export default {
  props: ["date"],
  mounted() {
    if (this.date === null) return false;
    if (this.date) {
      this.execution_date = new Date(this.date);
    }
  },
  data: () => ({
    execution_date: null
  }),
  methods: {
    notBeforeDate(date) {
      return date < new Date().setHours(0, 0, 0, 0);
    },
    notBeforeTime(date) {
      return date < new Date().setMinutes(20);
    }
  },
  components: {
    DatePicker
  }
};
</script>
