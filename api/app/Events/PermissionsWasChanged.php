<?php

namespace App\Events;

use App\Models\Core\Permission;
use App\Models\Core\Permissions\BoardPermission;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\Permissions\SystemPermission;
use App\Models\Core\User;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class PermissionsWasChanged implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    protected string $role_id;

    /**
     * Create a new event instance.
     *
     * @param string $role_id
     */
    public function __construct(string $role_id)
    {
        $this->role_id = $role_id;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return Channel|array
     */
    public function broadcastOn()
    {
        return new PresenceChannel('permissions.' . $this->role_id);
    }

    public function broadcastWith()
    {
        return [
            'permissions' => [
                'system' => SystemPermission::select('scope')->whereRoleId($this->role_id)->first(),
                'boards' => BoardPermission::select('board_id', 'scope')->whereRoleId($this->role_id)->get(),
                'columns' => ColumnPermission::select('board_id', 'column_id', 'scope')->whereRoleId($this->role_id)->get(),
            ]
        ];
    }
}
