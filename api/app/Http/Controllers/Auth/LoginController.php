<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Jobs\ProcessSendingPassword;
use App\Models\Core\Sanctum\PersonalAccessToken;
use App\Models\Core\FirebaseToken;
use App\Services\Auth\AuthService;
use App\Services\Core\UserService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Jenssegers\Agent\Agent;

class LoginController extends Controller
{
    protected AuthService $authService;
    protected UserService $userService;

    public function __construct(AuthService $authService, UserService $userService)
    {
        $this->authService = $authService;
        $this->userService = $userService;
    }

    public function findUser(LoginRequest $request)
    {
        $user = $this->userService->findUser($this->getLogin($request->get('login')));
        $password = $this->authService->generateNewPassword($user->id);
        Log::channel('pins')->info($password);
        ProcessSendingPassword::dispatch($user, $password);

        return [
            'avatar_name' => $user->avatar_name ?? null,
            'alias' => $user->alias ?? null,
            'name' => $user->name ?? null,
            'surname' => $user->surname ?? null,
            'email' => $user->email ?? null,
            'mobile_phone' => $user->mobile_phone ?? null,
        ];
    }

    public function generateQrData(Request $request)
    {
        return [
            'login' => $request->user()->mobile_phone,
            'password' => $this->authService->generateNewPassword($request->user()->id)
        ];
    }

    public function login(LoginRequest $request)
    {
        $password = '';
        if ($request->has('code')) $password = decrypt($request->get('code'));
        if ($request->has('password')) $password = $request->get('password');

        $agent = new Agent();
        $device = [
            'device_name' => $agent->device(),
            'device_type' => $agent->deviceType(),
            'platform' => $agent->platform(),
            'platform_version' => $agent->version($agent->platform()),
            'browser' => $agent->browser(),
            'browser_version' => $agent->version($agent->browser()),
            'ip' => $request->ip()
        ];

        $user = $this->userService->findUser($this->getLogin($request->get('login')));
        $this->authService->login($user, $password);
        $token = $request->user()->createToken('api key', $device)->plainTextToken;

        if ($request->has('firebaseToken')) {
            $firebaseToken = $request->get('firebaseToken');
            if (!FirebaseToken::where([['token', $firebaseToken],['user_id', $user->id]])->first()) {
                FirebaseToken::create(['token' => $firebaseToken, 'user_id' => $user->id]);
            }
        }

        return [
            'token' => $token,
            'user' => $request->user(),
            'permissions' => $request->user()->getPermissionsAttribute(),
            'tokens' => $this->tokens($request, $token)
        ];
    }

    public function logout(Request $request)
    {
        if ($request->has('firebaseToken')) {
            $firebaseToken = FirebaseToken::where([
                ['token', $request->get('firebaseToken')],['user_id', $request->user()->id]])->first();
            $firebaseToken->delete();
        }

        $token = PersonalAccessToken::findToken(
            str_replace('Bearer ', '', $request->header('Authorization'))
        );

        if ($request->user()->_id != $token->tokenable_id) abort(403);
        $token->delete();
    }

    public function user(Request $request)
    {
        $token = str_replace('Bearer ', '', $request->header('Authorization'));
        return [
            'user' => $request->user(),
            'permissions' => $request->user()->getPermissionsAttribute(),
            'tokens' => $this->tokens($request, $token)
        ];
    }

    protected function tokens(Request $request, $token)
    {
        $currentToken = PersonalAccessToken::findToken($token);

        return PersonalAccessToken::where([
            ['tokenable_id', $request->user()->_id], ['_id', '!=', $currentToken->_id]
        ])->get();
    }

    protected function getLogin(string $login)
    {
        if (Str::startsWith($login, '+7')) {
            return Str::substr($login, 2, strlen($login));
        }

        if (strlen($login) == 11 && Str::startsWith($login, '8')) {
            return Str::substr($login, 1, strlen($login));
        }

        return $login;
    }
}
