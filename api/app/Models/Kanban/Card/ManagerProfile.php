<?php

namespace App\Models\Kanban\Card;

use Jenssegers\Mongodb\Eloquent\Model;

class ManagerProfile extends Model
{
    protected $collection = 'kanban_card_manager_profiles';
    protected $guarded = [];

    protected $casts = [
        'new_room' => 'boolean',
        'room_plan' => 'boolean',
        'outsiders' => 'boolean',
        'internet' => 'boolean',
        'local_network' => 'boolean',
        'local_network_pull' => 'boolean',
        'local_network_arranges' => 'boolean',
        'telephony' => 'boolean',
        'ourVirtualPBX_apparatus' => 'boolean',
        'wifi' => 'boolean',
        'wifi_devices' => 'boolean',
        'wifi_2ssid' => 'boolean',
        'wifi_need_auth' => 'boolean',
        'wifi_oyspot' => 'boolean',
        'CCTV' => 'boolean',
        'trade_equipment_pos_need' => 'boolean',
        'trade_equipment_cashbox_need' => 'boolean',
        'trade_equipment' => 'boolean',
        'cctv_pro' => 'boolean',
        'cctv_sound' => 'boolean',
        'wifi_radar' => 'boolean',
        'it_outsourcing' => 'boolean',
        'iptv' => 'boolean',
        'iptv_box' => 'boolean',
    ];

}
