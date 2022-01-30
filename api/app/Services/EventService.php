<?php

namespace App\Services;

use App\Models\Core\Event;

class EventService
{
    public function create(array $args)
    {
        return Event::create($args);
    }
}
