<?php

namespace App\Console\Commands;

use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Attachment;
use Illuminate\Console\Command;

class ImportCovers extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-card-covers';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import covers';

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
        $cards = Card::all();
        foreach ($cards as $card) {
            if (isset($card->cover_id)) {
                $attachment = Attachment::where('id', $card->cover_id)->first();
                if (!$attachment) $card->unset('cover_id');
                else $card->update(['cover_id' => $attachment->_id]);
            }
        }
    }
}
