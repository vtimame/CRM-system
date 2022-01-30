<?php

namespace App\Models\Core;

use App\Models\Kanban\Card;
use Jenssegers\Mongodb\Eloquent\Model;

class Event extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'events';
    protected $dates = ['created_at'];
    protected $guarded = [];
    protected $with = ['children'];

    public function children()
    {
        return $this->hasMany(Event::class, 'parent_id', '_id');
    }

    public function user()
    {
        return $this->hasOne(User::class, '_id', 'user_id');
    }

    public function card()
    {
        return $this->hasOne(Card::class, '_id', 'card_id');
    }

    public function initiator()
    {
        return $this->hasOne(User::class, '_id', 'initiator_id');
    }
}
