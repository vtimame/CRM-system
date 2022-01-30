<?php

namespace App\Models\Kanban\Card;

use Jenssegers\Mongodb\Eloquent\Model;

class Address extends Model
{
    protected $collection = 'kanban_card_addresses';
    protected $guarded = [];
}
