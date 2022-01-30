<?php

use Illuminate\Support\Facades\Broadcast;

Broadcast::routes(['middleware' => ['api', 'auth:sanctum']]);
//Broadcast::channel('chat.{task_id}', \App\Broadcasting\MessagesChannel::class);

Broadcast::channel('notifications.{user_id}', function ($user, $user_id) {
    if ( $user->_id === $user_id) {
        return $user;
    }
});

Broadcast::channel('pbx.{user_id}', function ($user, $user_id) {
    if ( $user->_id === $user_id) {
        return $user;
    }
});

Broadcast::channel('permissions.{role_id}', function ($user, $role_id) {
    if ($user->role_id === $role_id) {
        return $user;
    }
});

Broadcast::channel('board.{board_id}', function ($user) {
    return $user;
});

Broadcast::channel('card.{card_id}', function ($user) {
    return $user;
});

Broadcast::channel('app', function ($user) {
    return $user;
});

Broadcast::channel('App.User.{user_id}', function ($user) {
    return $user;
});
