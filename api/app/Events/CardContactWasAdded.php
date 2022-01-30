<?php

namespace App\Events;

use App\Models\Kanban\Card\Address;
use App\Models\Kanban\Card\Contact;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class CardContactWasAdded implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected $contact;
    protected $card_id;

    /**
     * Create a new event instance.
     *
     * @param int $card_id
     * @param Contact $contact
     */
    public function __construct(int $card_id, Contact $contact)
    {
        $this->card_id = $card_id;
        $this->contact = $contact;
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
            'data' => $this->contact
        ];
    }
}
