<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Kanban\Card;
use App\Services\NotificationService;
use Illuminate\Http\Request;

class MembersController extends Controller
{
    protected NotificationService $notificationService;
    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    public function store(string $card_id, Request $request)
    {
        Card::find($card_id)->push('members', $request->get('member_id'), true);
        $event = Event::create([
            'type' => 'cardMemberWasAdded',
            'initiator_id' => $request->user()->id,
            'card_id' => $card_id,
            'member_id' => $request->get('member_id')
        ]);
        $this->notificationService->send([$request->get('member_id')], $event->_id);
    }

    public function destroy(string $card_id, string $user_id)
    {
        Card::find($card_id)->pull('members', $user_id);
    }
}
