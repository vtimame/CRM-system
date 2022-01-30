<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card;
use App\Models\Kanban\CardThumbnail;
use App\Models\Kanban\Column;
use Illuminate\Console\Command;

class CalculateCardPositions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'calculate:card-positions';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Calculate card positions';

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
        $cards = [];
        $this->info($this->description);
        $columns = Column::with('cards')->get();
        foreach ($columns as $column) {
            $cards[] = Card::whereColumnId($column->id)->orderBy('created_at', 'desc')->get()->each(function ($card, $key) {
                $card->position = $key;
                $card->save();
                $this->info('Card ' . $card->id . ' position updated');
            });
        }
    }
}
