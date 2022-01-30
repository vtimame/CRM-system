<?php

namespace App\Console\Commands;

use App\Models\Core\Department;
use App\Models\Core\Division;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportDivisions extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:divisions';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import divisions from yii database';

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
        Division::truncate();
        $this->info($this->description);
        $divisions = DB::connection('yii')->table('divisions')->get();
        $data = [];

        foreach ($divisions as $division) {
            $data[] = [
                'id' => $division->id,
                'department_id' => $this->getDepartmentId($division->idDepartment),
                'name' => $division->name,
                'created_at' => Carbon::now()->toDateTimeString()
            ];
        }

        if (!empty($data)) Division::insert($data);
    }

    protected function getDepartmentId(int $mysql_id)
    {
        $department = Department::where('id', $mysql_id)->first();
        return $department ? $department->_id : null;
    }
}
