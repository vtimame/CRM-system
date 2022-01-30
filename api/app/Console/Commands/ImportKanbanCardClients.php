<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Client;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanCardClients extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-clients';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban cards clients from yii database';

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
        $clients = DB::connection('yii')->table('cards_client_temp')->get();
        $data = [];

        foreach ($clients as $client) {
            $card_id = $this->getCardId($client->card_id);
            if (!$card_id) continue;

            $clientData = [
//                'id' => $client->id,
//                'card_id' => $card_id,
                'old_crm_id' => $client->old_crm_id,
                'services' => $client->services,
                'link' => $client->link,
                'new_address' => $client->new_address
            ];

            foreach ($clientData as $key => $item) {
                if ($item == null) unset($clientData[$key]);
            }

//            $data[] = $clientData;

            Card::find($card_id)->update([
                'client' => $clientData
            ]);
        }


//        if (!empty($data)) {
//            Client::truncate();
//            Client::insert($data);
//        }
    }

    protected function getCardId(int $mysql_id)
    {
        $card = Card::where('id', $mysql_id)->first();
        return $card ? $card->_id : null;
    }
}
