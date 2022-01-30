<?php

namespace App\Models\Pbx;

use Jenssegers\Mongodb\Eloquent\Model;

class Call extends Model
{
    protected $collection = 'pbx_calls';
    protected $guarded = [];
    public $timestamps = false;
}
