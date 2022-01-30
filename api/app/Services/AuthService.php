<?php

namespace App\Services;

use App\Http\Requests\LoginRequest;
use App\Models\Core\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\UnauthorizedException;
use Laravel\Passport\PersonalAccessTokenResult;

class AuthService
{
    public function login(LoginRequest $request): PersonalAccessTokenResult
    {
        $this->tryLogin($request->validated());
        $this->updateLastLoginAndIp($request->user(), $request->ip());
        return $this->createAccessToken($request->user());
    }

    public function logout(User $user) {
        $user->token()->revoke();
    }

    protected function tryLogin(array $credentials): void
    {
        if (!Auth::attempt($credentials)) {
            throw new UnauthorizedException('Invalid mobile phone or password', 1);
        }
    }

    protected function updateLastLoginAndIp(User $user, string $ip): void
    {
        $user->last_ip = $ip;
        $user->last_login_as = Carbon::now();
        $user->save();
    }

    protected function createAccessToken(User $user): PersonalAccessTokenResult
    {
        $tokenResult = $user->createToken('Api Access Token');
        $token = $tokenResult->token;
        $token->save();
        return $tokenResult;

    }
}
