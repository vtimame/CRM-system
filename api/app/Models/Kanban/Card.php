<?php

namespace App\Models\Kanban;

use App\Models\Core\Event;
use App\Models\Core\User;
use App\Models\Kanban\Board;
use App\Models\Kanban\Column;
use App\Models\Kanban\Card\Address;
use App\Models\Kanban\Card\Attachment;
use App\Models\Kanban\Card\Checklist;
use App\Models\Kanban\Card\Client;
use App\Models\Kanban\Card\Comment;
use App\Models\Kanban\Card\Contact;
use App\Models\Kanban\Card\ExploringProfile;
use App\Models\Kanban\Card\ManagerProfile;
use App\Models\Kanban\Card\Operator;
use Jenssegers\Mongodb\Eloquent\Model;
use Jenssegers\Mongodb\Eloquent\SoftDeletes;

class Card extends Model
{
    use SoftDeletes;

    protected $collection = 'kanban_cards';
    protected $guarded = [];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function move_events()
    {
        return $this->hasMany(Event::class, 'card_id', '_id')->where([
            ['type', 'cardWasMoved']
        ]);
    }

    public function waiting_calls()
    {
        return $this->hasMany(Event::class, 'card_id', '_id')->where([
            ['status', 'waiting'], ['render_type', 'call']
        ]);
    }

    public function waiting_meetings()
    {
        return $this->hasMany(Event::class, 'card_id', '_id')->where([
            ['status', 'waiting'], ['render_type', 'meeting']
        ]);
    }

    public function address()
    {
        return $this->hasOne(Address::class, 'card_id', '_id');
    }

    public function board()
    {
        return $this->hasOne(Board::class, '_id', 'board_id');
    }

    public function column()
    {
        return $this->hasOne(Column::class, '_id', 'column_id');
    }

    public function contacts()
    {
        return $this->hasMany(Contact::class, 'card_id', '_id');
    }

    public function manager_profile()
    {
        return $this->hasOne(ManagerProfile::class, '_id', 'manager_profile_id');
    }

    public function exploring_profile()
    {
        return $this->hasOne(ExploringProfile::class, '_id', 'exploring_profile_id');
    }

    public function client()
    {
        return $this->hasOne(Client::class, 'card_id', '_id');
    }

    public function operator()
    {
        return $this->hasOne(Operator::class, 'card_id', '_id');
    }

    public function attachments()
    {
        return $this->hasMany(Attachment::class, 'card_id', '_id');
    }

    public function attachments_count()
    {
        return count(Attachment::where('card_id', $this->_id)->get());
    }

//    public function comments_count()
//    {
//        return count(Comment::where('card_id', $this->_id)->get());
//    }

    public function comments()
    {
        return $this->hasMany(Comment::class, 'card_id', '_id');
    }

    public function checklists()
    {
        return $this->hasMany(Checklist::class, 'card_id', '_id');
    }

    public function cover()
    {
        return $this->hasOne(Attachment::class, '_id', 'cover_id');
    }
}
