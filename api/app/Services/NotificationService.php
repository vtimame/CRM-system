<?php

namespace App\Services;

use App\Events\NotificationWasReceived;
use App\Jobs\ProcessSendingFirebaseMessage;
use App\Models\Core\Notification;
use Illuminate\Support\Facades\Auth;
use Ixudra\Curl\Facades\Curl;

class NotificationService
{
    public function send($ids, $event_id)
    {
        foreach ($ids as $user_id)
        {
            $auth_user_id = Auth::check() ? Auth::user()->_id : null;
            if ($user_id == $auth_user_id) continue;
            $notification = $this->createEchoNotification($user_id, $event_id);
            ProcessSendingFirebaseMessage::dispatch($notification);
        }
    }

    protected function createEchoNotification(string $user_id, string $event_id): Notification
    {
        $notification = Notification::create(['user_id' => $user_id, 'event_id' => $event_id]);
        broadcast(new NotificationWasReceived($user_id, $notification));
        return $notification;
    }
}
