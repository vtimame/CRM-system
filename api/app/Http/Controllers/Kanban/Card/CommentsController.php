<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Events\CardCommentWasAdded;
use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Core\User;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Comment;
use App\Services\NotificationService;
use Illuminate\Http\Request;

class CommentsController extends Controller
{
    protected $notificationsService;
    public function __construct(NotificationService $notificationService)
    {
        $this->notificationsService = $notificationService;
    }

    public function store(string $card_id, Request $request)
    {
        $members = Card::find($card_id)->members;
        $comment = Comment::create(array_merge(
            $request->all(),
            [
                'card_id' => $card_id,
                'user_id' => $request->user()->id
            ]
        ));

//        $comment = Comment::find($comment->id);
//        if ($request->get('parent_id') == null) {
//            $event = $this->createEvent($card_id, $comment, 'cardCommentWasAdded');
//            $this->notificationsService->send($members, $event);
//        } else {
//            $answer_comment = Comment::find($request->get('parent_id'));
//            $event = $this->createEvent($card_id, $comment, '');
//            $this->notificationsService->send([$answer_comment->user->_id], $event);
//        }
//
//        broadcast(new CardCommentWasAdded($card_id, $comment))->toOthers();
//        return $comment;
    }

    protected function createEvent(string $card_id, Comment $comment, string $type)
    {
        return Event::create([
            'type' => $type,
            'initiator_id' => $comment->user_id,
            'card_id' => $card_id,
            'comment_id' => $comment->id
        ]);
    }
}
