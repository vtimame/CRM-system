<?php

namespace App\Models\Pbx;

use Jenssegers\Mongodb\Eloquent\Model;

class Settings extends Model
{
    protected $collection = 'pbx_settings';
    protected $guarded = [];
    public $timestamps = false;
}
