<?php

namespace App\Http\Controllers\Kanban;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Kanban\Card;
use App\Models\Kanban\Card\Comment;
use App\Models\Kanban\CardThumbnail;
use App\Models\Kanban\Column;
use App\Services\NotificationService;
use App\Services\ThumbnailService;
use Illuminate\Http\Request;

class ThumbnailsController extends Controller
{
    protected NotificationService $notificationsService;
    protected ThumbnailService $thumbnailService;
    public function __construct(ThumbnailService $thumbnailService, NotificationService $notificationService)
    {
        $this->thumbnailService = $thumbnailService;
        $this->notificationsService = $notificationService;
    }

    public function index(Request $request)
    {
        return $this->thumbnailService->findByPermissions($request);
    }

    public function move(Request $request)
    {
        $card = CardThumbnail::find($request->get('card_id'));

        $old_position = $card->position;

        $card->update([
            'column_id' => $request->get('new_column_id'),
            'position' => $request->get('new_position')
        ]);

        $this->thumbnailService->updatePositions(
            $request->get('old_column_id'),
            $old_position,
            'decrement'
        );

        $this->thumbnailService->updatePositions(
            $request->get('new_column_id'),
            $request->get('new_position')
        );

        $event = $this->createMoveEvent($request);
        $this->notificationsService->send($card->members, $event);
        return $this->thumbnailService->updateMembers($card);
    }

    protected function createMoveEvent(Request $request)
    {
        return Event::create([
            'type' => 'cardWasMoved',
            'initiator_id' => $request->user()->id,
            'card_id' => $request->get('card_id'),
            'new_column_id' => $request->get('new_column_id'),
            'old_column_id' => $request->get('old_column_id')
        ]);
    }
}
