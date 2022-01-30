<?php

use Illuminate\Support\Facades\Route;

Route::post('tickets', 'TicketsController@store');
Route::post('tickets/v2', 'TicketsController@store_v2');
Route::get('settings', 'SettingsController@index');
Route::put('settings', 'SettingsController@update');

Route::get('test', 'TicketsController@test');
