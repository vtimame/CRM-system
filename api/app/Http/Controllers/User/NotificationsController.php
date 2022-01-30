<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Models\Core\Notification;
use Carbon\Carbon;
use Illuminate\Http\Request;

class NotificationsController extends Controller
{
    public function index(Request $request)
    {
        return Notification::where('user_id', $request->user()->id)->orderBy('created_at', 'desc')->limit(500)->get();
    }

    public function update(string $notification_id, Request $request)
    {
        $notification = Notification::find($notification_id);
        if ($notification->user_id !== $request->user()->id) {
            abort(403);
        }

        $notification->read_at = Carbon::now()->toDateString();
        $notification->save();

        return $notification;
    }

    public function markAllAsRead(Request $request)
    {
        if ($request->get('notifications') != null) {
            $notifications = Notification::find($request->get('notifications'));
        } else {
            $notifications = $this->index($request);
        }

        foreach ($notifications as $notification)
        {
            if (!isset($notification->read_at)) {
                $notification->read_at = Carbon::now()->toDateString();
                $notification->save();
            }
        }

        return $this->index($request);
    }
}
