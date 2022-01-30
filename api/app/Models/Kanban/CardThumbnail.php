<?php

namespace App\Models\Kanban;

use App\Models\Core\User;
use App\Models\Kanban\Card\Address;
use App\Models\Kanban\Card\Attachment;
use App\Models\Kanban\Card\Comment;
use App\Models\Kanban\Card\Contact;
use Jenssegers\Mongodb\Eloquent\Model;
use Jenssegers\Mongodb\Eloquent\SoftDeletes;

class CardThumbnail extends Model
{
    use SoftDeletes;

    protected $collection = 'kanban_cards';
    protected $guarded = [];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    protected $with = [
        'address',
        'contacts',
        'members',
        'cover'
    ];

    protected $withCount = [
        'attachments',
        'comments'
    ];

    public function address()
    {
        return $this->hasOne(Address::class, 'card_id', '_id');
    }

    public function members()
    {
        return $this->belongsToMany(User::class, 'kanban_card_members', 'card_id', 'user_id');
    }

    public function contacts()
    {
        return $this->hasMany(Contact::class, 'card_id', '_id');
    }

    public function cover()
    {
        return $this->hasOne(Attachment::class, '_id', 'cover_id');
    }

    public function attachments()
    {
        return $this->hasMany(Attachment::class, 'card_id', '_id');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class, 'card_id', '_id');
    }
}
