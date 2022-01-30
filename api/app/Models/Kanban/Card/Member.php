<?php

namespace App\Models\Kanban\Card;

use Jenssegers\Mongodb\Eloquent\Model;

class Member extends Model
{
    protected $collection = 'kanban_card_members';
    protected $guarded = [];
}
