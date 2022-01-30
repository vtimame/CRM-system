<?php

namespace App\Models\Core\Permissions;

use Jenssegers\Mongodb\Eloquent\Model;

class BoardPermission extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'board_permissions';
    protected $guarded = [];
    public $timestamps = false;
}
