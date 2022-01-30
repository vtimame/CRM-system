<?php

namespace App\Services\Auth;

use App\Models\Core\Password;
use App\Models\Core\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\UnauthorizedException;

class AuthService
{
    /**
     * @param string $user_id
     * @return string
     * @throws \Exception
     */
    public function generateNewPassword(string $user_id): string
    {
        $password = random_int(100000, 999999);
        Password::updateOrCreate(['user_id' => $user_id],['password' => Hash::make($password)]);
        return $password;
    }

    public function login(User $user, ?string $password)
    {
        if (!$passwordInstance = Password::where('user_id', $user->id)->first()) $this->throwLoginError();
        if (!Hash::check($password, $passwordInstance->password)) $this->throwLoginError();
        Auth::login($user);
        $passwordInstance->delete();
    }

    protected function throwLoginError()
    {
        throw new UnauthorizedException('Не верный логин и пароль');
    }
}
