<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Contact;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Http\Request;

class ContactController extends Controller
{
    protected NotificationService $notificationService;
    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    public function store(string $card_id, Request $request)
    {
        $card = Card::find($card_id);
        $contact = Contact::create(array_merge(['card_id' => $card_id], $request->all()));
        $event = Event::create([
            'type' => 'cardContactWasAdded',
            'initiator_id' => $request->user()->id,
            'card_id' => $card_id
        ]);
        $this->notificationService->send($card->members, $event->_id);
        return $contact;
    }

    public function update(string $card_id, string $contact_id, Request $request)
    {
        Contact::find($contact_id)->update($request->all());
        return Contact::find($contact_id);
    }

    public function destroy(string $card_id, string $contact_id, Request $request)
    {
        Contact::findOrFail($contact_id)->delete();
    }
}
