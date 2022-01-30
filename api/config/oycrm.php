<?php

return [
    'permissions' => [
        'system' => [
            'scope' => [
                'view_boards_section',
                'add_boards',
                'edit_system_permissions'
            ]
        ],
        'board' => [
            'scope' => [
                'view_board',
                'add_columns',
                'rename_columns',
                'rename_board',
                'move_columns',
                'edit_column_permissions',
                'edit_board_permissions',
            ]
        ],
        'column' => [
            'scope' => [
                'view_column',
                'add_cards',
                'edit_card_description',
                'edit_card_title',
                'edit_card_address',
                'edit_card_cover',
                'add_card_attachments',
                'delete_card_attachments',
                'add_card_contacts',
                'edit_card_contacts',
                'delete_card_contacts',
                'view_manager_profile',
                'edit_manager_profile',
                'view_exploring_profile',
                'edit_exploring_profile',
                'add_card_checklists',
                'view_card_checklists',
                'edit_card_checklists',
                'delete_card_checklists',
                'add_card_checklist_checkboxes',
                'delete_card_checklist_checkboxes',
                'check_card_checklist_checkboxes',
                'add_card_members',
                'delete_card_members',
                'set_card_lead',
                'unset_card_lead',
                'leave_from_card',
                'add_card_meetings',
                'add_card_calls',
                'view_card_operators',
                'edit_card_operators',
                'view_card_clients',
                'edit_card_clients'
            ]
        ]
    ],
    'service' => [
        'oymailer' => env('OYMAILER_HOST', 'https://oymailier.oyster.su/api'),
        'fcm' => [
            'host' => env('FCM_HOST', 'http://localhost:4531')
        ],
        'sms' => [
            'host' => env('SMS_HOST', 'https://smsc.ru/sys/send.php'),
            'login' => env('SMS_LOGIN', 'oyster'),
            'password' => env('SMS_PASSWORD', '03ZnDsax%ui*W')
        ]
    ]
];
