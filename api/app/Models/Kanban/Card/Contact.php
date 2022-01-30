<?php

namespace App\Models\Kanban\Card;

use Jenssegers\Mongodb\Eloquent\Model;
use Jenssegers\Mongodb\Eloquent\SoftDeletes;

class Contact extends Model
{
    use SoftDeletes;

    protected $collection = 'kanban_card_contacts';
    protected $guarded = [];
}
