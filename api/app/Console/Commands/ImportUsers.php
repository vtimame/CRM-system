<?php

namespace App\Console\Commands;

use App\Models\Core\Division;
use App\Models\Core\User;
use App\Models\Core\UserRole;
use Carbon\Carbon;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ImportUsers extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'import:users';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Import users from yii database';

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

        $users = DB::connection('yii')->table('users')->get();
        foreach ($users as $user) {
            $fio = explode(' ', $user->fio);
            $exploded_public_phones = preg_replace('/\D/', '', explode(' ' , $user->tel)[0]);
            !empty($exploded_public_phones) ? $public_phones = $exploded_public_phones : [];

            if (count($fio) != 2) continue;
            if ($fio[1] == 'User') continue;

            $userData = [
                'name' => $fio[1],
                'surname' => $fio[0],
                'show' => true
            ];

            if ($user->id) $userData['id'] = $user->id;
            if ($user->avatar != 'man.png' && $user->avatar != 'woman.png') $userData['avatar_name'] = $user->avatar;
            if ($user->sex) $userData['sex'] = $user->sex == 'm' ? 0 : 1;
            if ($user->alias) $userData['alias'] = $user->alias;
            if ($user->email) $userData['email'] = $user->email;
            if ($user->mobile) $userData['mobile_phone'] = Str::substr($user->mobile, 1, 10);
            if ($user->office) $userData['office_phone'] = preg_replace('/\D/', '', $user->office);
            if (!empty($public_phones)) $userData['public_phones'] = $public_phones;
            if ($user->idDivision) $userData['division_id'] = $this->getDivisionId($user->idDivision);
            if ($user->role) $userData['role_id'] = $this->getRoleId($user->role);
            if ($user->birthday) $userData['birthday'] = Carbon::parse($user->birthday)->toDateTimeString();

            User::create($userData);
        }
    }

    protected function getRoleId(?int $mysql_id)
    {
        $role = UserRole::where('id', $mysql_id)->first();
        if (!$role) {
            $role = UserRole::where('id', -1)->first();
        }
        return $role->_id;
    }

    protected function getDivisionId(?int $mysql_id)
    {
        $division = Division::where('id', $mysql_id)->first();
        return $division ? $division->_id : null;
    }
}
