<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Comment;
use App\Models\Kanban\Card\Event;
use Carbon\Carbon;
use Illuminate\Console\Command;
use App\Models\Kanban\Card\Command as CardCommand;
use Illuminate\Support\Facades\DB;

class ImportKanbanCardsActions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-actions';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban card actions from yii database';

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
        $comments = DB::connection('yii')
            ->table('tasks_actions')->where('type', 'commentCard')->get();

        $calls = DB::connection('yii')
            ->table('tasks_actions')->where('type', 'commandCall')->get();

        $meetings = DB::connection('yii')
            ->table('tasks_actions')->where('type', 'commandMeeting')->get();



        $commentsData = [];
        $callsData = [];
        $meetingsData = [];

        foreach ($comments as $comment) {
            $card_id = $this->getCardId($comment->idCard);
            $user_id = $this->getUserId($comment->idUser);

            if (!$card_id || !$user_id) continue;

            $data = json_decode($comment->data);
            $commentsData[] = [
                'id' => $comment->id,
                'card_id' => $card_id,
                'render_type' => 'comment',
                'user_id' => $user_id,
                'parent_id' => $data->parent,
                'edited' => isset($data->edited) ? $data->edited == 'true' : false,
                'message' => $data->text,
                'created_at' => Carbon::parse($comment->date)->toDateTimeString()
            ];
        }

        foreach ($calls as $call) {
            if ($call->data == null) continue;
            $card_id = $this->getCardId($call->idCard);
            $user_id = $this->getUserId($call->idUser);

            if (!$card_id || !$user_id) continue;

            $data = json_decode($call->data);
            $callsData[] = [
                'id' => $call->id,
                'card_id' => $card_id,
                'user_id' => $user_id,
                'render_type' => 'call',
                'report_message' => isset($data->report) ? $data->report->text : null,
                'comment_message' => isset($data->comment) ? $data->comment : null,
                'command_type' => 'call',
                'status' => isset($data->status) ? $data->status : 'waiting',
                'closed_at' => isset($data->report) ? Carbon::parse($data->report->created_at) : null,
                'event_dt' => Carbon::parse($data->event_dt)->toDateTimeString(),
                'created_at' => Carbon::parse($call->date)->toDateTimeString()
            ];
        }

        foreach ($meetings as $meeting) {
            if ($meeting->data == null) continue;

            $card_id = $this->getCardId($meeting->idCard);
            $user_id = $this->getUserId($meeting->idUser);

            if (!$card_id || !$user_id) continue;

            $data = json_decode($meeting->data);
            $callsData[] = [
                'id' => $meeting->id,
                'card_id' => $card_id,
                'user_id' => $user_id,
                'render_type' => 'meeting',
                'report_message' => isset($data->report) ? $data->report->text : null,
                'comment_message' => isset($data->comment) ? $data->comment : null,
                'command_type' => 'meeting',
                'status' => isset($data->status) ? $data->status : 'waiting',
                'closed_at' => isset($data->report) ? Carbon::parse($data->report->created_at)->toDateTimeString() : null,
                'event_dt' => Carbon::parse($data->event_dt)->toDateTimeString(),
                'created_at' => Carbon::parse($meeting->date)->toDateTimeString()
            ];
        }




        if (!empty($commentsData)) {
//            Comment::truncate();
            \App\Models\Core\Event::insert($commentsData);
        }

//        if (!empty($callsData) || !empty($meetingsData)) {
//            CardCommand::truncate();
//        }

        if (!empty($callsData)) \App\Models\Core\Event::insert($callsData);

        if (!empty($meetingsData)) \App\Models\Core\Event::insert($meetingsData);

        $comments = \App\Models\Core\Event::where('render_type', 'comment')->get();
        foreach ($comments as $comment) {
            if ($comment->parent_id != null) {
                $comment->update(['parent_id' => $this->getParentId($comment->parent_id)]);
            }
        }

    }

    protected function getCardId(int $mysql_id)
    {
        $card = Card::where('id', $mysql_id)->first();
        return $card ? $card->_id : null;
    }

    protected function getUserId(int $mysql_id)
    {
        $user = User::where('id', $mysql_id)->first();
        return $user ? $user->_id : null;
    }

    protected function getParentId(int $mysql_id)
    {
        $parent = \App\Models\Core\Event::where('id', $mysql_id)->first();
        return $parent->_id;
    }
}
