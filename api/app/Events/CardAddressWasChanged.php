<?php

namespace App\Events;

use App\Models\Kanban\Card\Address;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CardAddressWasChanged implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected $address;
    protected $card_id;

    /**
     * Create a new event instance.
     *
     * @param int $card_id
     * @param Address $address
     */
    public function __construct(int $card_id, Address $address)
    {
        $this->card_id = $card_id;
        $this->address = $address;
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
            'data' => $this->address
        ];
    }
}
