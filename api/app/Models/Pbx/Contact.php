<?php

namespace App\Models\Pbx;

use Jenssegers\Mongodb\Eloquent\Model;

class Contact extends Model
{
    protected $collection = 'pbx_contacts';
    protected $guarded = [];
    public $timestamps = false;
}
