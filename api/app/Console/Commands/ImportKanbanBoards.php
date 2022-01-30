<?php

namespace App\Console\Commands;

use App\Models\Kanban\Board;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanBoards extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-boards';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban boards from yii database';

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
        $boards = DB::connection('yii')->table('tasks_boards')->get();

        $i = 0;
        $data = [];
        foreach ($boards as $board) {
            $data[] = [
                'id' => $board->id,
                'name' => $board->name,
                'created_at' => Carbon::now()->addMinutes($i)->toDateTimeString()
            ];

            $i = $i + 10;
        }

        if (!empty($data)) {
            Board::truncate();
            Board::insert($data);
        }
    }
}
