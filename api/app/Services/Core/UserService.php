<?php

namespace App\Services\Core;

use App\Models\Core\User;
use Illuminate\Database\Eloquent\ModelNotFoundException;

class UserService
{
    /**
     * @param string $login
     * @return User
     */
    public function findUser(string $login): User
    {
        $user = User::where('mobile_phone', $login)->orWhere('email', $login)->orWhere('alias', $login)->first();
        if (!$user || $user->deleted_at) throw new ModelNotFoundException('User not found');
        return $user;
    }
}
