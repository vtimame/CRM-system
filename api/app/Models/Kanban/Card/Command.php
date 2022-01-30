<?php

namespace App\Models\Kanban\Card;

use App\Models\Core\User;
use Carbon\Carbon;
use Jenssegers\Mongodb\Eloquent\Model;

class Command extends Model
{
    protected $collection = 'kanban_card_commands';
    protected $guarded = [];

    protected $with = [
        'user'
    ];

    protected $casts = [
        'json_message' => 'array'
    ];

    protected $appends = ['type'];

    public function getTypeAttribute()
    {
        return 'command';
    }

    public function user()
    {
        return $this->hasOne(User::class, '_id', 'user_id');
    }

    public function setEventDtAttribute($value)
    {
        $this->attributes['event_dt'] = Carbon::parse($value);
    }

    public function setJsonMessageAttribute($value)
    {
        $this->attributes['json_message'] = json_encode($value);
    }
}
