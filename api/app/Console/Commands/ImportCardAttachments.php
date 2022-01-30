<?php

namespace App\Console\Commands;

use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Attachment;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportCardAttachments extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-attachments';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban card attachments from yii database';

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
        $attachments = DB::connection('yii')->table('tasks_attachments')->get();

        $data = [];
        foreach ($attachments as $attachment) {
            $card_id = $this->getCardId($attachment->idCard);
            $user_id = $this->getUserId($attachment->idUser);

            if (!$card_id || !$user_id) continue;

            $data[] = [
                'id' => $attachment->id,
                'card_id' => $card_id,
                'user_id' => $user_id,
                'bytes' => $attachment->bytes,
                'name' => $attachment->name,
                'created_at' => Carbon::parse($attachment->uploadDate)->toDateTimeString()
            ];
        }

        if (!empty($data)) {
            Attachment::truncate();
            Attachment::insert($data);

            $attachments = Attachment::all();
            foreach ($attachments as $attachment) {
                Card::find($attachment->card_id)->push('attachments', $attachment->_id, true);
                $attachment->unset('card_id');
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
}
