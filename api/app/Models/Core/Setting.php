<?php

namespace App\Models\Core;

use Jenssegers\Mongodb\Eloquent\Model;

class Setting extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'settings';
    protected $guarded = [];
}
