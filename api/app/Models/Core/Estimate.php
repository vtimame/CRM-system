<?php

namespace App\Models\Core;

use Jenssegers\Mongodb\Eloquent\Model;

class Estimate extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'estimates';
    protected $guarded = [];
}
