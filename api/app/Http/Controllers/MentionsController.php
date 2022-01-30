<?php

namespace App\Http\Controllers;

use App\Models\Core\Event;
use App\Services\NotificationService;
use Illuminate\Http\Request;

class MentionsController extends Controller
{
    protected $notificationService;
    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    public function send(Request $request) {
        $mentionEvent = Event::create([
            'type' => 'cardMentionWasAdded',
            'initiator_id' => $request->user()->id,
            'card_id' => $request->get('card_id'),
        ]);
        $this->notificationService->send($request->get('ids'), $mentionEvent->_id);
    }
}
