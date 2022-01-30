<?php

namespace App\Models\Site;

use Jenssegers\Mongodb\Eloquent\Model;

class Settings extends Model
{
    protected $collection = 'site_settings';
    protected $guarded = [];
    public $timestamps = false;
}
