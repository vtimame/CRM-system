<?php

namespace App\Console\Commands;

use App\Models\Core\UserRole;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportUserRoles extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:user-roles';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import user roles from yii database';

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
        $roles = DB::connection('yii')->table('roles')->get();
        $data = [
            [
                'id' => -1,
                'name' => 'Без роли',
                'created_at' => Carbon::now()->toDateTimeString()
            ]
        ];

        foreach ($roles as $role) {
            $data[] = [
                'id' => $role->id,
                'name' => $role->name,
                'created_at' => Carbon::now()->toDateTimeString()
            ];
        }

        if (!empty($data)) {
            UserRole::truncate();
            UserRole::insert($data);
        }
    }
}
