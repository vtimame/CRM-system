<?php

namespace App\Models\Core;

use Jenssegers\Mongodb\Eloquent\Model;

class Notification extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'notifications';
    protected $dates = ['created_at'];
    protected $guarded = [];
    protected $with = ['event'];

    public function event()
    {
        return $this->hasOne(Event::class, '_id', 'event_id');
    }
}
