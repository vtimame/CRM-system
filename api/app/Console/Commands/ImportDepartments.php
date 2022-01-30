<?php

namespace App\Console\Commands;

use App\Models\Core\Department;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportDepartments extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:departments';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import departments from yii database';

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
        Department::truncate();
        $this->info($this->description);
        $departments = DB::connection('yii')->table('departments')->get();
        $data = [];

        foreach ($departments as $department) {
            $data[] = [
                'id' => $department->id,
                'name' => $department->name,
                'created_at' => Carbon::now()->toDateTimeString()
            ];
        }

        if (!empty($data)) Department::insert($data);
    }
}
