<?php

namespace App\Http\Controllers\Site;

use App\Events\CardWasAdded;
use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Contact;
use App\Models\Kanban\Column;
use App\Models\Site\Settings;
use App\Models\Site\Ticket;
use App\Services\NotificationService;
use Illuminate\Http\Request;
use Carbon\Carbon;

class TicketsController extends Controller
{
    protected NotificationService $notificationService;

    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    public function store_v2(Request $request)
    {
        $now = Carbon::now()->format('Y-m-d H:i');
        $siteSettings = Settings::first();
        $ticketsColumn = Column::find($siteSettings->tickets_column_id);

        if ($request->header('Authorization') != 'Basic ' . env('SITE_API_KEY')) {
            return response()->json(['status' => 'Unauthorized'], 401);
        }

        $lastTicket = Ticket::orderBy('created_at', 'desc')->first();
        $users = User::whereIn('role_id', $siteSettings->tickets_creator_roles)->get();
        $creator_id = $this->getCreatorId($lastTicket, $users);

        Ticket::create(array_merge($request->all(), ['creator_id' => $creator_id, 'created_at' => $now]));

        $card = Card::create([
            'title' =>  $request->get('dev') == true ? 'Тестовая заявка' : 'Заявка' . ' ['. $now .']',
            'column_id' => $ticketsColumn->_id,
            'board_id' => $ticketsColumn->board_id,
            'creator_id' => $creator_id,
            'members' => [$creator_id],
            'manager_profile' => ['learn_about_as' => 'site'],
            'address' => $this->getEmptyAddress(),
            'description' => $request->get('description')
        ]);

        Contact::create($request->get('contact') + ['card_id' => $card->_id]);
        $broadcastCard = Card::with('contacts', 'cover', 'waiting_calls', 'waiting_meetings', 'board', 'column')->find($card->id);
        broadcast(new CardWasAdded($broadcastCard));

        $event = Event::create([
            'type' => 'newSiteTicket',
            'card_id' => $card->_id
        ]);

        $this->notificationService->send([$creator_id], $event->_id);

        return $request->all();
    }

    public function store(Request $request)
    {
        $siteSettings = Settings::first();
        $ticketsColumn = Column::find($siteSettings->tickets_column_id);

        if ($request->header('Authorization') != 'Basic ' . env('SITE_API_KEY')) {
            return response()->json(['status' => 'Unauthorized'], 401);
        }

        $lastTicket = Ticket::orderBy('DATE_FROM', 'desc')->first();
        $users = User::whereIn('role_id', $siteSettings->tickets_creator_roles)->get();

        $creator_id = $this->getCreatorId($lastTicket, $users);

        Ticket::create(array_merge($request->all(), ['creator_id' => $creator_id]));

        $card = Card::create([
            'title' =>  'Заявка [' . $request->get('DATE_FROM') . ']',
            'column_id' => $ticketsColumn->_id,
            'board_id' => $ticketsColumn->board_id,
            'creator_id' => $creator_id,
            'members' => [$creator_id],
            'description' => $request->get('PRODUCT') . "\n" .
                $request->get('FORM_NAME') . "\n" .
                $request->get('USER_COMPANY') . "\n" .
                $request->get('PRODUCT') . "\n" .
                $request->get('MASSAGE') . "\n" .
                $request->get('USER_ADDRESS') . "\n" .
                $request->get('USER_PHONE'),
            'manager_profile' => ['learn_about_as' => 'site'],
            'address' => $this->getEmptyAddress()
        ]);

        broadcast(new CardWasAdded($card));

        $event = Event::create([
            'type' => 'newSiteTicket',
            'card_id' => $card->_id
        ]);

        $this->notificationService->send([$creator_id], $event->_id);
        return $lastTicket;
    }

    private function getEmptyAddress(): array
    {
        return [
            'street' => "",
            'street_num' => "",
            'litera' => "",
            'building' => "",
            'floor' => "",
            'office' => "",
            'room_type' => "other"
        ];
    }

    private function getCreatorId($lastTicket, $users)
    {
        $creators = [];
        foreach ($users as $user) {
            if ($user->onVacation == true) continue;
            $creators[] = $user->_id;
        }

        if (!$lastTicket->creator_id) {
            $creator_id = $creators[0];
        } else {
            $creatorIndex = array_search($lastTicket->creator_id, $creators);
            $creator_id = array_key_exists($creatorIndex + 1, $creators) ? $creators[$creatorIndex + 1] : $creators[0];
        }

        return $creator_id;
    }
}
