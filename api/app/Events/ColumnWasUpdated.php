<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class ColumnWasUpdated implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected array $data;
    protected string $column_id;

    /**
     * Create a new event instance.
     *
     * @param string $column_id
     * @param array $data
     */
    public function __construct(string $column_id, array $data)
    {
        $this->column_id = $column_id;
        $this->data = $data;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return Channel|array
     */
    public function broadcastOn()
    {
        return new PresenceChannel('board.' . $this->column_id);
    }

    public function broadcastWith()
    {
        return [
            'data' => $this->data
        ];
    }
}
