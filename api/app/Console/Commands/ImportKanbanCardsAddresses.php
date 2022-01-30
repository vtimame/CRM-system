<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Address;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanCardsAddresses extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-addresses';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban cards addresses from yii database';

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
        $addresses = DB::connection('yii')->table('tasks_cards_addresses')
            ->leftJoin('tasks_cards', 'tasks_cards.id', '=', 'tasks_cards_addresses.card_id')
            ->select('tasks_cards_addresses.*', 'tasks_cards.room as room_type')->get();
        $data = [];
        foreach ($addresses as $address) {
            $card_id = $this->getCardId($address->card_id);
            if (!$card_id) continue;

            if ($address->street_num == null) $address->street_num = 'Не указано';
            if ($address->room_type == null) $address->room_type = 'other';
            if ($address->building == '' || $address->building == null) unset($address->building);
            if ($address->litera == '' || $address->litera == null) unset($address->litera);
            if ($address->office == '' || $address->office == null) unset($address->office);
            if (!$address->floor || $address->floor == '') unset($address->office);

//            $address->card_id = $this->getCardId($address->card_id);
//            $data[] = json_decode(json_encode($address), true);

            unset($address->id);
            unset($address->card_id);

            Card::find($card_id)->update([
                'address' => $address
            ]);
        }

//        if (!empty($data)) {
//            Address::truncate();
//            Address::insert($data);
//        }
    }

    protected function getCardId(int $mysql_id)
    {
        $card = Card::where('id', $mysql_id)->first();
        return $card ? $card->_id : null;
    }
}
