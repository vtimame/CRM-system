<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Core\User;
use App\Services\NotificationService;
use Illuminate\Http\Request;

class MentionsController extends Controller
{
    protected $notificationsService;
    public function __construct(NotificationService $notificationService)
    {
        $this->notificationsService = $notificationService;
    }

    public function store(string $card_id, Request $request)
    {
        $members = User::find($request->get('mentions'));
        foreach ($members as $member) {
            $event = Event::create([
                'type' => 'cardMentionWasAdded',
                'initiator_id' => $request->user()->id,
                'card_id' => $card_id,
                'member_id' => $member->id
            ]);
            $this->notificationsService->send([$member], $event);
        }
    }
}
