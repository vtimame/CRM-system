<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Operator;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ImportKanbanCardOperators extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-operators';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban cards operators from yii database';

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
        $operators = DB::connection('yii')->table('cards_operators_temp')->get();
        $data = [];

        foreach ($operators as $operator) {
            $card_id = $this->getCardId($operator->card_id);
            if (!$card_id) continue;

            $operatorData = [
//                'id' => $operator->id,
//                'card_id' => $card_id,
                'fio' => $operator->fio,
                'phone' => Str::substr(preg_replace('/\D/', '', $operator->phone), 1, 10),
                'pseudoname' => $operator->pseudoname,
            ];

            foreach ($operatorData as $key => $item) {
                if ($item == null) unset($operatorData[$key]);
            }

//            $data[] = $operatorData;

            Card::find($card_id)->update([
                'operator' => $operatorData
            ]);
        }

//        if (!empty($data)) {
//            Operator::truncate();
//            Operator::insert($data);
//        }
    }

    protected function getCardId(int $mysql_id)
    {
        $card = Card::where('id', $mysql_id)->first();
        return $card ? $card->_id : null;
    }
}
