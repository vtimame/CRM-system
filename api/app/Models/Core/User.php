<?php

namespace App\Models\Core;

use App\Events\NotificationWasReceived;
use App\Models\Core\Permissions\BoardPermission;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\Permissions\SystemPermission;
use Jenssegers\Mongodb\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use App\Services\Auth\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use Notifiable, HasApiTokens;

    protected $connection = 'mongodb';
    protected $collection = 'users';
    protected $guarded = [];

    protected $hidden = [
        'password',
    ];

    protected $dates = [
        'created_at',
        'updated_at',
        'password_expires_at'
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
        'password_expires_at' => 'datetime',
        'show' => 'boolean',
        'isAdmin' => 'boolean'
    ];

    protected $with = [
        'role',
        'division',
    ];

    public function password()
    {
        return $this->hasOne(Password::class);
    }

    public function role()
    {
        return $this->hasOne(UserRole::class, '_id', 'role_id');
    }

    public function division()
    {
        return $this->hasOne(Division::class, '_id', 'division_id');
    }

    public function appendPermissions()
    {
        $this->append('permissions');
    }

    public function getPermissionsAttribute()
    {
        return [
            'system' => SystemPermission::whereRoleId($this->role_id)->first(),
            'boards' => BoardPermission::whereRoleId($this->role_id)->get(),
            'columns' => ColumnPermission::whereRoleId($this->role_id)->get(),
        ];
    }
}
