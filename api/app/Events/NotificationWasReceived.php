<?php

namespace App\Events;

use App\Models\Core\Notification;
use App\Models\Core\User;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class NotificationWasReceived implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected Notification $notification;
    protected string $user_id;

    /**
     * Create a new event instance.
     *
     * @param string $user_id
     * @param Notification $notification
     */
    public function __construct(string $user_id, Notification $notification)
    {
        $this->user_id = $user_id;
        $this->notification = $notification;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return Channel|array
     */
    public function broadcastOn()
    {
        return new PresenceChannel('notifications.' . $this->user_id);
    }

    public function broadcastWith()
    {
        return [
            'notification' => $this->notification
        ];
    }
}
