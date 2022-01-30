export default {
  data: () => ({
    permissions_types: [
      {
        section_name: "Основное",
        opened: false,
        rules: [
          { title: "Просмотр колонки", name: "view_column" },
          { title: "Создание карточек", name: "add_cards" },
          { title: "Редактировать описание", name: "edit_card_description" },
          { title: "Видимость карточек", name: "view_cards", component: true }
        ]
      },
      {
        section_name: "Услуги",
        opened: false,
        rules: [
          { title: "Просмотр цены", name: "view_services_price" },
          { title: "Редактирование", name: "edit_services" }
        ]
      },
      {
        section_name: "Созвоны и встречи",
        opened: false,
        rules: [
          { title: "Добавление звонков", name: "add_calls" },
          { title: "Добавление встреч", name: "add_meetings" },
          { title: "Видимость звонков", name: "view_calls", component: true },
          { title: "Видимость встреч", name: "view_meetings", component: true }
        ]
      },
      {
        section_name: "Данные",
        opened: false,
        rules: [
          { title: "Редактировать заголовок", name: "edit_card_title" },
          { title: "Редактировать адрес", name: "edit_card_address" },
          { title: "Редактировать обложку", name: "edit_card_cover" },
          { title: "Загружать вложения", name: "add_card_attachments" },
          { title: "Изменять вложения", name: "edit_card_attachments" },
          { title: "Удалять вложения", name: "delete_card_attachments" },
          { title: "Редактировать узлы", name: "edit_card_node" }
        ]
      },
      {
        section_name: "Контакты",
        opened: false,
        rules: [
          { title: "Добавление", name: "add_card_contacts" },
          { title: "Редактирование", name: "edit_card_contacts" },
          { title: "Удаление", name: "delete_card_contacts" }
        ]
      },
      {
        section_name: "Анкета менеджера",
        opened: false,
        rules: [
          { title: "Просмотр", name: "view_manager_profile" },
          { title: "Добавление", name: "edit_manager_profile" }
        ]
      },
      {
        section_name: "Анкета разведки",
        opened: false,
        rules: [
          { title: "Просмотр", name: "view_exploring_profile" },
          { title: "Добавление", name: "edit_exploring_profile" }
        ]
      },
      {
        section_name: "Чек-листы",
        opened: false,
        rules: [
          { title: "Просмотр", name: "view_card_checklists" },
          { title: "Создание", name: "add_card_checklists" }
          // { title: "Изменение", name: "edit_card_checklists" },
          // { title: "Удаление", name: "delete_card_checklists" },
          // {
          //   title: "Добавление элементов",
          //   name: "add_card_checklist_checkboxes"
          // },
          // {
          //   title: "Удаление элементов",
          //   name: "delete_card_checklist_checkboxes"
          // },
          // {
          //   title: "Отметка элементов",
          //   name: "check_card_checklist_checkboxes"
          // }
        ]
      },
      {
        section_name: "Участники",
        opened: false,
        rules: [
          { title: "Добавление", name: "add_card_members" },
          { title: "Удаление", name: "delete_card_members" },
          { title: "Назначать ведущего", name: "set_card_lead" },
          { title: "Назначать создателя", name: "set_card_creator" },
          { title: "Снимать роль ведущего", name: "unset_card_lead" },
          { title: "Покинуть карточку", name: "leave_from_card" }
        ]
      },
      {
        section_name: "Операторы и клиенты",
        opened: false,
        rules: [
          { title: "Просмотр операторов", name: "view_card_operators" },
          { title: "Редактирование операторов", name: "edit_card_operators" },
          { title: "Просмотр клиентов", name: "view_card_clients" },
          { title: "Редактирование клиентов", name: "edit_card_clients" }
        ]
      },
      {
        section_name: "Прочее",
        opened: false,
        rules: [
          {
            title: "Напоминать об актуализации услуг",
            name: "notify_services_actualization"
          }
        ]
      }
    ]
  })
};
