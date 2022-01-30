<?php

namespace App\Http\Controllers\Kanban;

use App\Events\CardWasChanged;
use App\Http\Controllers\Controller;
use App\Http\Requests\Kanban\UpdateCardRequest;
use App\Models\Core\Event;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Contact;
use App\Models\Kanban\Card\Member;
use App\Models\Kanban\CardThumbnail;
use App\Models\Kanban\Column;
use App\Services\NotificationService;
use App\Services\ThumbnailService;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\DB;

class CardsController extends Controller
{
    protected NotificationService $notificationService;
    protected ThumbnailService$thumbnailService;
    public function __construct(ThumbnailService $thumbnailService, NotificationService $notificationService)
    {
        $this->thumbnailService = $thumbnailService;
        $this->notificationService = $notificationService;
    }

    public function indexRaw(Request $request)
    {
        return Card::select('title', 'board_id', 'creator_id', 'column_id')->get();
    }

    public function index(Request $request)
    {
        $cards = [];
        $role_id = $request->user()->role_id;
        $board_id = $request->get('board_id');

        $permissions = ColumnPermission::where([['role_id', $role_id],['board_id', $board_id]])->get();
        foreach ($permissions as $permission) {
            $query = Card::with('contacts', 'cover', 'waiting_calls', 'waiting_meetings')
                ->where([['board_id', $board_id],['column_id', $permission->column_id],['in_archive', '!=', true]])
                ->orderBy('updated_at', 'desc');

            if (!isset($permission->view_cards)) continue;
            switch ($permission->view_cards['value']) {
                case 'all':
                    $cards[] = $query->get();
                    break;
                case 'creator':
                    $cards[] = $query->where('creator_id', $request->user()->id)->get();
                    break;
                case 'lead':
                    $cards[] = $query->where('lead_id', $request->user()->id)->get();
                    break;
                case 'member':
                    $cards[] = $query->where('members', 'all', [$request->user()->id])->get();
                    break;
                case 'role_list':
                    $users = User::whereIn('role_id', $permission->view_cards['role_list'])->get();
                    $cards[] = $query->whereIn('creator_id', $users->pluck('_id'))->get();
                default:
                    break;
            }
        }

        return Arr::flatten($cards);
    }

    public function show(string $card_id, Request $request)
    {
        return Card::with('contacts', 'cover', 'waiting_calls', 'waiting_meetings', 'board', 'column')->find($card_id);
    }

    public function update(string $card_id, Request $request)
    {
        Card::findOrFail($card_id)->update($request->all());
        return $request->all();
    }

    public function store(Request $request)
    {
        $card = Card::create($request->all());

        if ($request->has('contacts')) {
            foreach ($request->get('contacts') as $contact) {
                Contact::create($contact + ['card_id' => $card->_id]);
            }
        }

        return Card::with('contacts')->findOrFail($card->id);
    }

    public function creatorNotification(string $card_id, Request $request)
    {
        $event = Event::create([
            'type' => 'newCreator',
            'initiator_id' => $request->user()->id,
            'card_id' => $card_id,
            'user_id' => $request->get('creator_id')
        ]);

        $this->notificationService->send([$request->get('creator_id')], $event->_id);
    }

    public function destroy(string $card_id, Request $request)
    {
        Card::find($card_id)->delete();
    }

    public function autoAddMembers(string $card_id, Request $request)
    {
        $card = Card::find($card_id);
        $column = Column::find($card->column_id);
        $list = [$card->creator_id];
        if (isset($card->lead_id)) $list[] = $card->lead_id;
        if (isset($column->autoadd_users)) $list = array_merge($list, $column->autoadd_users);

        $card->update(['members' => $list]);

        foreach ($list as $item) {
            $event = Event::create([
                'type' => 'cardMemberWasAdded',
                'initiator_id' => $request->user()->id,
                'card_id' => $card_id,
                'member_id' => $item
            ]);
            $this->notificationService->send([$item], $event->_id);
        }

        return $list;
    }

    public function createMoveEvent(string $card_id, Request $request)
    {
        $card = Card::find($card_id);
        $event = Event::create([
            'type' => 'cardWasMoved',
            'initiator_id' => $request->user()->id,
            'card_id' => $card_id
        ] + $request->all());
        $this->notificationService->send($card->members, $event->_id);
    }
}
