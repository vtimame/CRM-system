<?php

namespace App\Console\Commands;

use App\Models\Core\Event;
use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Column;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportEvents extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:events';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import events from yii database';

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
        Event::truncate();
        $this->info($this->description);
        $events = DB::connection('yii')
            ->table('tasks_actions')
            ->where([
                ['type', '!=', 'commentCard'],
                ['type', '!=', 'commandCall'],
                ['type', '!=', 'commandMeeting'],
            ])
            ->get();

        $eventsData = [];
        foreach ($events as $event) {
            $card_id = $this->getCardId($event->idCard);
            $user_id = $this->getUserId($event->idUser);

            if (!$card_id || !$user_id) continue;

            $type = $this->getEventType($event);
            $data = $this->getEventData($event);
            if ($type == null || $data == null) continue;
            $eventsData[] = array_merge(
                [
                    'type' => $this->getEventType($event),
                    'render_type' => 'event',
                    'initiator_id' => $user_id,
                    'card_id' => $card_id
                ],
                $data,
                ['created_at' => Carbon::parse($event->date)->toDateString()]
            );
        }

        if (!empty($eventsData)) Event::insert($eventsData);
    }

    protected function getEventType($event)
    {
        switch ($event->type) {
            case 'addMember':
                return 'cardMemberWasAdded';
            case 'editComment':
                return 'cardCommentWasEdited';
            case 'moveCard':
                return 'cardWasMoved';
            case 'cardMemberSetLead':
                return 'cardLeadWasAssign';
            case 'removeMember':
                return 'cardMemberWasRemoved';
            case 'addAttachment':
                return 'cardAttachmentWasUploaded';
            case 'removeAttachment':
                return 'cardAttachmentWasRemoved';
            default:
                return null;
        }
    }

    protected function getEventData($event)
    {
        $data = json_decode($event->data);
        switch ($event->type) {
            case 'addMember':
            case 'removeMember':
                return [ 'member_id' => $this->getUserIdByName($data->member->fio) ];
            case 'editComment':
                return [
                    'comment_id' => $data->comment,
                    'old_text' => $data->old_text,
                    'new_text' => $data->new_text
                ];
            case 'moveCard':
                $new_column_id = $this->getColumnIdByName($data->new);
                $old_column_id = $this->getColumnIdByName($data->old);
                if ($new_column_id == null || $old_column_id == null) return null;
                return [
                    'new_column_id' => $new_column_id,
                    'old_column_id' => $old_column_id
                ];
            case 'cardMemberSetLead':
                return [
                    'lead_id' => $this->getUserIdByName($data->member->fio)
                ];
//            case 'addAttachment':
//                dd($data);
////            case 'removeAttachment':
////                return 'cardAttachmentWasRemoved';
            default:
                return [];
        }
    }

    protected function getUserIdByName($fio)
    {
        $fio = explode(' ', $fio);
        $user = User::where([['surname', $fio[0]], ['name', $fio[1]]])->first();
        if (!$user) return null;
        return $user->_id;
    }

    protected function getColumnIdByName($name)
    {
        $column = Column::whereName($name)->first();
        if (!$column) return null;
        return $column->_id;
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
}
