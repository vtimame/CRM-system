<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Contact;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ImportKanbanCardsContacts extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-contacts';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban cards contacts from yii database';

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
        $contacts = DB::connection('yii')->table('tasks_persons')->get();

        $data = [];
        $now = Carbon::now()->toDateTimeString();

        foreach ($contacts as $contact) {
            $phone = Str::substr(preg_replace('/\D/', '', $contact->phone), 1, 10);

            $card_id = $this->getCardId($contact->idCard);
            if (!$card_id) continue;

            $contactData = [
                'id' => $contact->id,
                'card_id' => $card_id,
                'name' => $contact->name,
                'surname' => $contact->surname,
                'patronymic' => $contact->patronymic,
                'email' => $contact->email,
                'phones' => [
                    ['phone' => $phone]
                ],
                'position' => $contact->position,
                'created_at' => $now
            ];

            foreach ($contactData as $key => $item) {
                if ($item == null) unset($contactData[$key]);
            }

            $data[] = $contactData;

//            Card::find($card_id)->push('contacts', $contactData);
        }

        if (!empty($data)) {
            Contact::truncate();
            Contact::insert($data);
        }
    }

    protected function getCardId(int $mysql_id)
    {
        $card = Card::where('id', $mysql_id)->first();
        return $card ? $card->_id : null;
    }
}
