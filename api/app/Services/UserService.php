<?php

namespace App\Services;

use App\Models\Core\User;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class UserService
{
    public function findByMobilePhone(string $mobile_phone): User
    {
        $user = User::whereMobilePhone($mobile_phone)->first();
        if (!$user) throw new ModelNotFoundException('User not found');
        return $user;
    }
}
