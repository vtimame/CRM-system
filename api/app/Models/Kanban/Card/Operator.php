<?php

namespace App\Models\Kanban\Card;

use Jenssegers\Mongodb\Eloquent\Model;

class Operator extends Model
{
    protected $collection = 'kanban_card_operators';
    protected $guarded = [];
}
