<?php

namespace App\Http\Controllers\PBX\CFD;

use App\Events\CallWasReceived;
use App\Http\Controllers\Controller;
use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Contact;
use App\Models\Pbx\Settings;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class CallsController extends Controller
{
    protected array $response;

    public function incoming(Request $request)
    {
        $settings = Settings::first();
        $this->response = [
            'number' => $settings->managers_queue_number,
            'queue' => $settings->managers_queue_number,
            'type' => 'queue'
        ];

        $client_number = substr($request->get('number'), -10);
        Log::channel('pbx')->info('Client number: ' . $client_number);

        $contact = Contact::where('phones.phone', $client_number)->first();
        Log::channel('pbx')->info('Contact: ' . $contact);

        if (!$contact) {
            Log::channel('pbx')->info('Contact ' . $client_number . ' not found. Return default extension');
            return $this->response;
        }

        $card = Card::find($contact->card_id);
        Log::channel('pbx')->info('Card: ' . $card);
        if (!$card) {
            Log::channel('pbx')->info('Card ' . $contact->card_id . ' not found. Return default extension');
            return $this->response;
        }

        $manager = User::find($card->creator_id);
        Log::channel('pbx')->info('Manager: ' . $manager);
        if ($manager && $manager->office_phone != null) {
            $this->response = [
                'number' => $manager->office_phone,
                'type' => 'extension'
            ];
            broadcast(new CallWasReceived($manager->_id, [
                'contact' => $contact,
                'card' => $card
            ]));
        }
        else {
            Log::channel('pbx')->info('User not found. Return default extension');
            return $this->response;
        }

        return $this->response;
    }
}
