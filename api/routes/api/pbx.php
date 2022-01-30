<?php

use Illuminate\Support\Facades\Route;

Route::get('settings', 'SettingsController@index')->middleware('auth:sanctum');
Route::put('settings', 'SettingsController@update')->middleware('auth:sanctum');

Route::post('cfd/call/incoming', 'CFD\\CallsController@incoming');
Route::get('crm/contacts', 'CRM\\ContactsController@show');
Route::post('crm/contacts', 'CRM\\ContactsController@store');
Route::post('crm/calls', 'CRM\\CallsController@store');
