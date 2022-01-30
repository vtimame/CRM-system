<?php

namespace App\Models\Kanban\Card;

use App\Models\Core\User;
use Jenssegers\Mongodb\Eloquent\Model;
use Jenssegers\Mongodb\Eloquent\SoftDeletes;

class Attachment extends Model
{
    use SoftDeletes;

    protected $collection = 'kanban_card_attachments';
    protected $guarded = [];

    protected $with = [
        'user'
    ];

    public function user()
    {
        return $this->hasOne(User::class, '_id', 'user_id');
    }
}
