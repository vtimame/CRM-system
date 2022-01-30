<?php

namespace App\Models\Core\Permissions;

use Jenssegers\Mongodb\Eloquent\Model;

class ColumnPermission extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'column_permissions';
    protected $guarded = [];
    public $timestamps = false;
}
