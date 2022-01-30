<?php

namespace App\Models\Core\Permissions;

use Jenssegers\Mongodb\Eloquent\Model;

class SystemPermission extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'system_permissions';
    protected $guarded = [];
    public $timestamps = false;
}
