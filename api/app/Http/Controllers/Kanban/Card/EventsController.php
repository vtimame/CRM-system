<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Services\EventService;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Http\Request;

class EventsController extends Controller
{
    protected NotificationService $notificationService;
    public function __construct(NotificationService $notificationService)
    {
        $this->notificationService = $notificationService;
    }

    public function index(string $card_id, Request $request)
    {
        $card = Card::find($card_id);
        $calls = [];
        $meetings = [];
        $other_events = Event::with('user')->where([
            ['card_id', $card_id], ['parent_id', null], ['render_type', '!=', 'call'], ['render_type', '!=', 'meeting']
        ])->get();

        $permissions = ColumnPermission::where([
            ['role_id', $request->user()->role_id],['board_id', $card->board_id],['column_id', $card->column_id]
        ])->first();

        if (isset($permissions->view_calls)) {
            $query = Event::with('user')->where([['card_id', $card_id],
                ['parent_id', null], ['render_type', 'call']]);
            switch ($permissions->view_calls['value']) {
                case 'all':
                    $calls = $query->get();
                    break;
                case 'initiator':
                    $calls = $query->where('user_id', $request->user()->_id)->get();
                    break;
                case 'role_list':
                    $users = User::whereIn('role_id', $permissions->view_calls['role_list'])->get();
                    $calls = $query->whereIn('user_id', $users->pluck('_id'))->get();
                    break;
                default:
                    break;
            }
        }

        if (isset($permissions->view_meetings)) {
            $query = Event::with('user')->where([['card_id', $card_id],
                ['parent_id', null], ['render_type', 'meeting']]);
            switch ($permissions->view_meetings['value']) {
                case 'all':
                    $meetings = $query->get();
                    break;
                case 'initiator':
                    $meetings = $query->where('user_id', $request->user()->_id)->get();
                    break;
                case 'role_list':
                    $users = User::whereIn('role_id', $permissions->view_calls['role_list'])->get();
                    $meetings = $query->whereIn('user_id', $users->pluck('user_id'))->get();
                    break;
                default:
                    break;
            }
        }

        $other_events = collect($other_events->concat($calls)->concat($meetings));
        $sorted = $other_events->sortByDesc('created_at');
        return $sorted->values()->all();
    }

    public function store(string $card_id, Request $request)
    {
        $event = Event::create(array_merge($request->all(), ['user_id' => $request->user()->id]));
        $event->load('user');
        $event->load('children');

        $card = Card::where('_id', $event->card_id)->first();
        $card->update(['updated_at' => Carbon::now()->toDateTimeString()]);
        if ($request->get('render_type') == 'comment') {
            $card->update(['comments_count' => $card->comments_count + 1]);
            if ($request->get('parent_id') != null) {
                $answer_comment = Event::find($request->get('parent_id'));
                $commentEvent = Event::create([
                    'type' => 'cardAnswerWasAdded',
                    'initiator_id' => $request->user()->id,
                    'card_id' => $card_id,
                    'comment_id' => $answer_comment->_id
                ]);
                $this->notificationService->send([$answer_comment->user_id], $commentEvent->_id);
            } else {
                $commentEvent = Event::create([
                    'type' => 'cardCommentWasAdded',
                    'initiator_id' => $request->user()->id,
                    'card_id' => $card_id,
                    'comment_id' => $event->_id
                ]);
                $this->notificationService->send($card->members, $commentEvent->_id);
            }
        }

        return $event;
    }

    public function update(string $card_id, string $event_id, Request $request)
    {
        Event::find($event_id)->update($request->all());
    }
}
