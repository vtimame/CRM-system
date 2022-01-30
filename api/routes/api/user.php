<?php

use Illuminate\Support\Facades\Route;

Route::get('notifications', 'NotificationsController@index');
Route::put('notifications/{notification_id}', 'NotificationsController@update');
Route::put('notifications', 'NotificationsController@markAllAsRead');

Route::get('actions', 'ActionsController@index');
