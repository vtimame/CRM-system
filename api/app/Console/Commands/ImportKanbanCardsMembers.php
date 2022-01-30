<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Member;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanCardsMembers extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-members';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban card members from yii database';

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
        $members = DB::connection('yii')->table('users_tasks_cards')->get();
        $data = [];

        foreach ($members as $member) {
            $card = Card::where('id', $member->tasks_cards_id)->first();
            $user = User::where('id', $member->users_id)->first();

            if (!$card || !$user) continue;
            $card->push('members', $user->_id, true);
        }
    }
}
