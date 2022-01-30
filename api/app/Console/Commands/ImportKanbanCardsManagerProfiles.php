<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card\ManagerProfile;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanCardsManagerProfiles extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-manager-profiles';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import Kanban card manager profiles';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        $this->info($this->description);
        $managers = DB::connection('yii')->table('tasks_cards_data')->get();

        $data = [];
        foreach ($managers as $manager) {
            $profileData = [];
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->new_room) $profileData['new_room'] = $manager->new_room;
//            if ($manager->room_plan) $profileData['room_plan'] = $manager->room_plan;
//            if ($manager->outsiders) $profileData['outsiders'] = $manager->outsiders;
//            if ($manager->when_contact) $profileData['when_contact'] = $manager->when_contact;
//            if ($this->boolMutator($manager->internet)) $profileData['internet'] = $this->boolMutator($manager->internet);
//            if ($manager->internet_speed) $profileData['internet_speed'] = $manager->internet_speed;
//            if ($this->boolMutator($manager->local_network)) $profileData['local_network'] = $this->boolMutator($manager->local_network);
//            if ($this->boolMutator($manager->local_network_pull)) $profileData['local_network_pull'] = $this->boolMutator($manager->local_network_pull);
//            if ($manager->local_network_pm_count) $profileData['local_network_pm_count'] = $manager->local_network_pm_count;
//            if ($this->boolMutator($manager->local_network_arranges)) $profileData['local_network_arranges'] = $this->boolMutator($manager->local_network_arranges);
//            if ($this->boolMutator($manager->telephony)) $profileData['telephony'] = $this->boolMutator($manager->telephony);
//            if ($manager->telephony_type) $profileData['telephony_type'] = $manager->telephony_type;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;
//            if ($manager->id) $profileData['id'] = $manager->id;

            $profileData = [
                'id' => $manager->id,
                'new_room' => $manager->new_room,
                'room_plan' => $manager->room_plan,
                'outsiders' => $manager->outsiders,
                'when_contact' => $manager->when_contact,
                'internet' => $this->boolMutator($manager->internet),
                'internet_speed' => $manager->internet_speed,
                'local_network' => $this->boolMutator($manager->local_network),
                'local_network_pull' => $this->boolMutator($manager->local_network_pull),
                'local_network_pm_count' => $manager->local_nework_pm_count,
                'local_network_arranges' => $this->boolMutator($manager->local_network_arranges),
                'telephony' => $this->boolMutator($manager->telephony),
                'telephony_type' => $manager->telephony_type,
                'ownPBX_model' => $manager->ownPBX_model,
                'ownPBX_lines' => $manager->ownPBX_lines,
                'ownPBX_numbers' => $manager->ownPBX_numbers,
                'ownVirtualPBX_numbers' => $manager->ownVirtualPBX_numbers,
                'ownVirtualPBX_connections' => $manager->ownVirtualPBX_connections,
                'ourVirtualPBX_lines' => $manager->ourVirtualPBX_lines,
                'ourVirtualPBX_numbers' => $manager->ourVirtualPBX_numbers,
                'ourVirtualPBX_apparatus' => $this->boolMutator($manager->ourVirtualPBX_apparatus),
                'ourVirtualPBX_apparatus_type' => $manager->ourVirtualPBX_apparatus_type,
                'ourVirtualPBX_apparatus_count' => $manager->ourVirtualPBX_apparatus_count,
                'wifi' => $this->boolMutator($manager->wifi),
                'wifi_devices' => $this->boolMutator($manager->wifi_devices),
                'wifi_2ssid' => $manager->wifi_2ssid,
                'wifi_need_auth' => $manager->wifi_need_auth,
                'wifi_access' => $manager->wifi_access,
                'wifi_oyspot' => $manager->wifi_oyspot,
                'CCTV' => $this->boolMutator($manager->CCTV),
                'CCTV_location' => $manager->CCTV_location,
                'trade_equipment_pos_count' => $manager->trade_equipment_pos_count,
                'trade_equipment_pos_need' => $this->boolMutator($manager->trade_equipment_pos_need),
                'trade_equipment_pos_type' => $manager->trade_equipment_pos_type,
                'trade_equipment_cashbox_count' => $manager->trade_equipment_cashbox_count,
                'trade_equipment_cashbox_need' => $this->boolMutator($manager->trade_equipment_cashbox_need),
                'trade_equipment_cashbox_type' => $manager->trade_equipment_cashbox_type,
                'trade_equipment' => $this->boolMutator($manager->trade_equipment),
                'cctv_cameras_count' => $manager->cctv_cameras_count,
                'cctv_pro' => $manager->cctv_pro ?? 0,
                'cctv_sound' => $manager->cctv_sound ?? 0,
                'wifi_radar' => $manager->wifi_radar ?? 0,
                'it_outsourcing' => $this->boolMutator($manager->it_outsourcing),
                'iptv' => $this->boolMutator($manager->iptv),
                'iptv_type' => $manager->iptv_type,
                'iptv_screens_count' => $manager->iptv_screens_count,
                'iptv_box' => $manager->iptv_box,
                'wifi_vendor' => $manager->wifi_vendor,
                'created_at' => Carbon::now()->toDateTimeString()
            ];

            foreach ($profileData as $key => $item) {
                if ($item == null) unset($profileData[$key]);
            }

            $data[] = $profileData;

        }

        if (!empty($data)) {
            ManagerProfile::truncate();
            ManagerProfile::insert($data);
        }
    }

    protected function getDate(?string $date)
    {
        return $date != null ? Carbon::parse($date) : null;
    }

    private function boolMutator($var){
        switch ($var) {
            case 'no':
                $var = 0;
                return $var;
            case 'yes':
                $var = 1;
                return $var;
            case 'null':
                $var = null;
                return $var;
        }
        return null;
    }

    private function AtcMutator($var){
        switch ($var) {
            case 'ownPBX':
                $var = 31;
                return $var;
            case 'ownVirtualPBX':
                $var = 32;
                return $var;
            case 'ourVirtualPBX':
                $var = 33;
                return $var;
        }
        return null;
    }

    private function EqMutator($var){
        switch ($var) {
            case 'sim':
                $var = 28;
                return $var;
            case 'wifi':
                $var = 29;
                return $var;
            case 'ls':
                $var = 30;
                return $var;
        }
        return null;
    }

    private function IptvMutator($var){
        switch ($var) {
            case 'hotel':
                $var = 34;
                return $var;
            case 'office':
                $var = 35;
                return $var;
            case 'public':
                $var = 36;
                return $var;
        }
        return null;
    }

    private function PbxMutator($var){
        switch ($var) {
            case 'analog':
                $var = 37;
                return $var;
            case 'sip':
                $var = 38;
                return $var;
            case 'unknown':
                $var = 39;
                return $var;
        }
        return null;
    }

    private function ProdMutator($var){
        switch ($var) {
            case 'Ruckus':
                $var = 25;
                return $var;
            case 'Mikrotik':
                $var = 26;
                return $var;
            case 'Unifi':
                $var = 27;
                return $var;
        }
        return null;
    }

}
