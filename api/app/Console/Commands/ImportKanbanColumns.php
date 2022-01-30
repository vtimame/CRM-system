<?php

namespace App\Console\Commands;

use App\Models\Kanban\Board;
use App\Models\Kanban\Column;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportKanbanColumns extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:kanban-columns';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import kanban columns from yii database';

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
        $columns = DB::connection('yii')->table('tasks_lists')->get();

        $data = [];
        foreach ($columns as $column) {
            $board_id = $this->getBoardId($column->board_id);
            if ($board_id) {
                $data[] = [
                    'id' => $column->id,
                    'board_id' => $board_id,
                    'name' => $column->name,
                    'position' => $column->position,
                    'created_at' => Carbon::now()->toDateTimeString()
                ];
            }
        }

        if (!empty($data)) {
            Column::truncate();
            Column::insert($data);
        }
    }

    protected function getBoardId(int $mysql_id)
    {
        $board = Board::where('id', $mysql_id)->first();
        return $board ? $board->_id : null;
    }
}
