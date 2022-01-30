<?php

namespace App\Models\Kanban\Card;

use Jenssegers\Mongodb\Eloquent\Model;

class Checklist extends Model
{
    protected $collection = 'kanban_card_checklists';
    protected $guarded = [];
}
