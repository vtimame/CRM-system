<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Kanban\Card\Command;
use App\Models\Kanban\Card\Comment;
use Illuminate\Http\Request;

class ActionsController extends Controller
{
    public function index(string $card_id, Request $request)
    {
        return [
            'comments' => Comment::whereCardId($card_id)->whereParentId(null)->get(),
            'events' => Event::where('card_id', $card_id)->get(),
            'calls' => Command::whereCardId($card_id)->whereCommandType('call')->get(),
            'meetings' => Command::whereCardId($card_id)->whereCommandType('meeting')->get(),
        ];
    }
}
