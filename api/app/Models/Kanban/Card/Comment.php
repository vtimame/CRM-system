<?php

namespace App\Models\Kanban\Card;

use App\Models\Core\User;
use Jenssegers\Mongodb\Eloquent\Model;

class Comment extends Model
{
    protected $collection = 'kanban_card_comments';
    protected $guarded = [];

    protected $with = [
        'children',
//        'user'
    ];

    protected $casts = [
        'json_message' => 'array'
    ];

    protected $appends = ['type'];

    public function getTypeAttribute()
    {
        return 'comment';
    }

    public function children()
    {
        return $this->hasMany(Comment::class, 'parent_id', '_id');
    }

    public function user()
    {
        return $this->hasOne(User::class, '_id', 'user_id');
    }

    public function setJsonMessageAttribute($value)
    {
        $this->attributes['json_message'] = json_encode($value);
    }

}
