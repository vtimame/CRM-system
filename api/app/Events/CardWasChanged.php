<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CardWasChanged implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected $data;
    protected $card_id;

    /**
     * Create a new event instance.
     *
     * @param int $card_id
     * @param array $data
     */
    public function __construct(int $card_id, array $data)
    {
        $this->card_id = $card_id;
        $this->data = $data;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return Channel|array
     */
    public function broadcastOn()
    {
        return new PresenceChannel('card.' . $this->card_id);
    }

    public function broadcastWith()
    {
        return [
            'data' => $this->data
        ];
    }
}
