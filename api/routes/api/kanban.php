<?php

use Illuminate\Support\Facades\Route;

Route::get('boards', 'BoardsController@index');
Route::get('raw/boards', 'BoardsController@rawIndex');
Route::post('boards', 'BoardsController@store');
Route::put('boards/{board_id}', 'BoardsController@update');
Route::get('columns', 'ColumnsController@index');
Route::get('raw-columns', 'ColumnsController@rawIndex');
Route::post('columns', 'ColumnsController@store');
Route::put('columns/{column_id}', 'ColumnsController@update');
Route::get('columns/{column_id}/autoadd', 'Column\\AutoaddController@show');
Route::post('columns/{column_id}/autoadd', 'Column\\AutoaddController@store');
Route::delete('columns/{column_id}/autoadd', 'Column\\AutoaddController@destroy');
Route::post('thumbnails', 'ThumbnailsController@index');
Route::put('thumbnails/move', 'ThumbnailsController@move');

Route::get('raw/cards', 'CardsController@indexRaw');
Route::post('cards/{card_id}/creator-notification', 'CardsController@creatorNotification');
Route::apiResource('cards', 'CardsController')
    ->only(['show', 'update', 'store', 'index', 'destroy'])->parameter('cards', 'card_id');

Route::post('cards/{card_id}/contact', 'Card\\ContactController@store');
Route::put('cards/{card_id}/contact/{contact_id}', 'Card\\ContactController@update');
Route::delete('cards/{card_id}/contact/{contact_id}', 'Card\\ContactController@destroy');

Route::post('cards/{card_id}/autoaddMembers', 'CardsController@autoAddMembers');
Route::post('cards/{card_id}/createMoveEvent', 'CardsController@createMoveEvent');

Route::get('checklists', 'Card\\ChecklistController@index');
Route::post('checklists', 'Card\\ChecklistController@store');
Route::put('checklists/{id}', 'Card\\ChecklistController@update');

Route::get('attachments', 'Card\\AttachmentsController@index');
Route::put('attachments/{attachment_id}', 'Card\\AttachmentsController@update');
Route::post('cards/{card_id}/attachments', 'Card\\AttachmentsController@store');
Route::delete('cards/{card_id}/attachments/{attachment_id}', 'Card\\AttachmentsController@destroy');

Route::get('cards/{card_id}/events', 'Card\\EventsController@index');
Route::post('cards/{card_id}/events', 'Card\\EventsController@store');
Route::put('cards/{card_id}/events/{event_id}', 'Card\\EventsController@update');

//Route::get('cards/{card_id}/actions', 'Card\\ActionsController@index');
//Route::post('cards/{card_id}/comments', 'Card\\CommentsController@store');
//Route::post('cards/{card_id}/commands', 'Card\\CommandsController@store');
//Route::put('cards/{card_id}/commands', 'Card\\CommandsController@update');
//Route::post('cards/{card_id}/mentions', 'Card\\MentionsController@store');
Route::post('cards/{card_id}/members', 'Card\\MembersController@store');
Route::delete('cards/{card_id}/members/{user_id}', 'Card\\MembersController@destroy');
