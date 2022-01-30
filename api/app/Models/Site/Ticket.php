<?php

namespace App\Models\Site;

use Jenssegers\Mongodb\Eloquent\Model;

class Ticket extends Model
{
    protected $collection = 'site_tickets';
    protected $guarded = [];
    public $timestamps = false;
}
