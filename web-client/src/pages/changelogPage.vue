<template>
  <div class="changelog-page">
    <div v-for="(note, i) in notes" :key="i">
      <div class="changelog-page__date">{{ note.date }}</div>
      <div v-for="(section, o) in note.sections" :key="o">
        <strong>{{ section.title }}</strong>
        <ul class="changelog-page__changelog-list">
          <li
            v-for="(item, u) in section.items"
            :key="u"
            class="changelog-page__changelog-list-item"
          >
            <div>
              <span class="badge" :class="[`badge-${item.badge.type}`]">{{
                item.badge.label
              }}</span>
              {{ item.text }}
            </div>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import moment from "moment";

export default {
  computed: {
    notes: function() {
      return [
        {
          date: this.getDate("2020-10-02 12:10"),
          sections: [
            {
              title: "Web CRM",
              items: [
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Узлы в карточках"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Видимость колонок в правах"
                }
              ]
            }
          ]
        },
        {
          date: this.getDate("2020-09-10 12:45"),
          sections: [
            {
              title: "Web CRM",
              items: [
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Воронка продаж"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Статистика по звонкам и встречам"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Статистика по услугам"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Метки"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Новые уведомелния"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Удаление карточек"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text:
                    "softDelete (Удаленные карточки подлежат восстановлению)"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Интеграция с сайтом"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Назначение заявок в порядке очереди"
                }
              ]
            }
          ]
        },
        {
          date: this.getDate("2020-08-04 13:20"),
          sections: [
            {
              title: "Web CRM",
              items: [
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Новые чек-листы"
                }
              ]
            }
          ]
        },
        {
          date: this.getDate("2020-07-31 13:15"),
          sections: [
            {
              title: "Web CRM",
              items: [
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Редактирование комментариев"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Редактирование вложений"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Включение/Отключение компонентов карточек"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Итеграция с АТС (Входящие звонки)"
                }
              ]
            }
          ]
        },
        {
          date: this.getDate("2020-07-29 18:15"),
          sections: [
            {
              title: "Web CRM",
              items: [
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Дата создания карточки"
                },
                {
                  badge: {
                    type: "danger",
                    label: "Удалено"
                  },
                  text: "Скорость интернета в анкете менеджера"
                }
              ]
            }
          ]
        },
        {
          date: this.getDate("2020-07-22 12:40"),
          sections: [
            {
              title: "Мобильное приложение",
              items: [
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Авторизация по QR-коду"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Исправлены ошибки в фильтре по создателям карточек"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Исправлены ошибки в уведомлениях"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Упоминания в комментариях"
                },
                {
                  badge: {
                    type: "warning",
                    label: "Обновлено"
                  },
                  text: "Рендеринг комментариев"
                }
              ]
            },
            {
              title: "Web CRM",
              items: [
                {
                  badge: {
                    type: "warning",
                    label: "Обновлено"
                  },
                  text: "Рендеринг комментариев"
                }
              ]
            }
          ]
        },
        {
          date: this.getDate("2020-07-21 19:47"),
          sections: [
            {
              title: "Web CRM",
              items: [
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Смена создателя"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Снятие ведущего"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Разделение уведомлений по категориям"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Исправлены мелкие ошибки"
                },
                {
                  badge: {
                    type: "danger",
                    label: "Удалено"
                  },
                  text: '"Узнал о нас" в анкете менеджера'
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: '"Источник" в анкете менеджера'
                }
              ]
            },
            {
              title: "Мобильное приложение",
              items: [
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: 'Раздел "Задачи"'
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Pull to refresh",
                  description: "123"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Разделение уведомлений по категориям"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Проверка прав в анкете разведки"
                },
                {
                  badge: {
                    type: "primary",
                    label: "Исправлено"
                  },
                  text: "Исправлена ошибка в ответах на комментарии"
                },
                {
                  badge: {
                    type: "success",
                    label: "Добавлено"
                  },
                  text: "Фильтр по пользователям в досках и задачах"
                },
                {
                  badge: {
                    type: "warning",
                    label: "Обновлено"
                  },
                  text: "Визуальное обновление компонентов приложения"
                }
              ]
            }
          ]
        }
      ];
    }
  },
  methods: {
    getDate(date) {
      return moment(date)
        .locale("ru")
        .calendar();
    }
  }
};
</script>

<style lang="scss" scoped>
@import "~open-color/open-color";
@import "src/assets/sass/mixins";

.changelog-page {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 12px;
  overflow-y: auto;
  background-color: white;
  @include scrollbars(4px, $oc-gray-5, $oc-gray-3);

  &__date {
    font-size: 1.3rem;
    font-weight: 600;
  }

  &__changelog-list {
    list-style: none;

    &-item {
      display: flex;
      align-items: center;

      .badge {
        margin-right: 0.5rem;
      }
    }
  }
}
</style>
