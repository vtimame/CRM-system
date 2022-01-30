<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class BoardWasUpdated implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected array $data;
    protected string $board_id;

    /**
     * Create a new event instance.
     *
     * @param string $board_id
     * @param array $data
     */
    public function __construct(string $board_id, array $data)
    {
        $this->board_id = $board_id;
        $this->data = $data;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return Channel|array
     */
    public function broadcastOn()
    {
        return new PresenceChannel('board.' . $this->board_id);
    }

    public function broadcastWith()
    {
        return [
            'data' => $this->data
        ];
    }
}
