<?php

namespace App\Models\Kanban\Card;

use Jenssegers\Mongodb\Eloquent\Model;

class Client extends Model
{
    protected $collection = 'kanban_card_clients';
    protected $guarded = [];
}
