<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use App\Models\Kanban\Card\ExploringProfile;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanCardsExploringProfiles extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-exploring-profiles';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban card exploring profiles from yii database';

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

        $explorers = DB::connection('yii')->table('tasks_cards_exploring_data')->get();

        $data = [];
        foreach ($explorers as $explorer) {

            if (User::find($explorer->idUser)) {
                $profileData = [
                    'id' => $explorer->id,
                    'user_id' => $explorer->idUser,
                    'YK' => $explorer->YK,
                    'room_plan' => $explorer->room_plan || 0,
                    'roof' => $explorer->roof,
                    'entrance' => $explorer->entrance,
                    'entrance_other' => $explorer->entrance_other,
                    'window' => $explorer->window,
                    'window_other' => $explorer->window_other,
                    'track' => $explorer->track,
                    'point' => $explorer->point,
                    'point_other' => $explorer->point_other,
                    '_220V' => $explorer->_220V || 0,
                    'how_to_lead' => $explorer->how_to_lead,
                    'how_to_post' => $explorer->how_to_post,
                    'time_limit' => $explorer->time_limit,
                    'project_for_approval' => $explorer->project_for_approval || 0,
                    'employee_lists' => $explorer->employee_lists || 0,
                    'guarantee_letters' => $explorer->guarantee_letters || 0,
                    'created_at' => $this->DateMootator($explorer->date)
                ];

                foreach ($profileData as $key => $item) {
                    if ($item == null) unset($profileData[$key]);
                }

                $data[] = $profileData;
            }
        }

        if (!empty($data)) {
            ExploringProfile::truncate();
            ExploringProfile::insert($data);
        }
    }

    private function DateMootator($var)
    {
        return Carbon::parse($var);
    }

}
