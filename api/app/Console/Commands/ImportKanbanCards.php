<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use App\Models\Kanban\Board;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\ManagerProfile;
use App\Models\Kanban\Card\ExploringProfile;
use App\Models\Kanban\Column;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanCards extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-cards';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban cards from yii database';

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
        $cards = DB::connection('yii')->table('tasks_cards')
            ->leftJoin('tasks_lists', 'tasks_cards.idList', '=', 'tasks_lists.id')
            ->select('tasks_cards.*', 'tasks_lists.board_id')->get();

        foreach ($cards as $card) {
            if ($card->in_archive) continue;
            $cardData = [];

            $board_id = $this->getBoardId($card->board_id);
            $column_id = $this->getColumnId($card->idList);
            if (!$board_id || !$column_id) continue;

            $manager_profile_id = $this->getManagerProfileId($card->idData);
            $exploring_profile_id = $this->getExploringProfileId($card->idExploring);

            if ($card->id) $cardData['id'] = $card->id;
            if ($card->name) $cardData['title'] = $card->name;
            if ($card->comment) $cardData['description'] = $card->comment;
            if ($card->positionInList) $cardData['position'] = $card->positionInList;
            if ($card->idList) $cardData['column_id'] = $column_id;
            if ($card->board_id) $cardData['board_id'] = $board_id;
            if ($card->idAttachmentCover) $cardData['cover_id'] = $card->idAttachmentCover;
            if ($card->idUser) $cardData['creator_id'] = $this->getUserId($card->idUser);
            if ($card->idLead) $cardData['lead_id'] = $this->getUserId($card->idLead);
//            if ($card->idData) $cardData['manager_profile_id'] = $this->getManagerProfileId($card->idData);
//            if ($card->idExploring) $cardData['exploring_profile_id'] = $this->getExploringProfileId($card->idExploring);
            if ($card->created_at) $cardData['created_at'] = Carbon::parse($card->created_at)->toDateTimeString();
            $cardData['updated_at'] = Carbon::parse($card->created_at)->toDateTimeString();

            if ($manager_profile_id) {
                $manager_profile = ManagerProfile::find($manager_profile_id);
                $cardData['manager_profile'] = $manager_profile;
            }

            if ($exploring_profile_id) {
                $exploring_profile = ExploringProfile::find($manager_profile_id);
                $cardData['exploring_profile'] = $exploring_profile;
            }

            $data[] = $cardData;
        }

        if (!empty($data)) {
            Card::truncate();
            Card::insert($data);
        }
    }

    protected function getUserId(?int $mysql_id)
    {
        $user = User::where('id', $mysql_id)->first();
        return $user ? $user->_id : null;
    }

    protected function getBoardId(?int $mysql_id)
    {
        $board = Board::where('id', $mysql_id)->first();
        return $board ? $board->_id : null;
    }

    protected function getColumnId(?int $mysql_id)
    {
        $column = Column::where('id', $mysql_id)->first();
        return $column ? $column->_id : null;
    }

    protected function getManagerProfileId(?int $mysql_id)
    {
        $profile = ManagerProfile::where('id', $mysql_id)->first();
        return $profile ? $profile->_id : null;
    }

    protected function getExploringProfileId(?int $mysql_id)
    {
        $profile = ExploringProfile::where('id', $mysql_id)->first();
        return $profile ? $profile->_id : null;
    }
}
