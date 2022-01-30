<?php

use Illuminate\Support\Facades\Route;

Route::group([
    'middleware' => 'auth:sanctum'
], function () {
    Route::get('users', 'UsersController@index');
    Route::post('users', 'UsersController@store');
    Route::get('users/{user_id}', 'UsersController@show');
    Route::put('users/{user_id}', 'UsersController@update');
    Route::post('users/{user_id}/avatar', 'UsersController@loadAvatar');
    Route::get('roles', 'RolesController@index');

    Route::post('mentions', 'MentionsController@send');

    Route::get('divisions', 'DivisionsController@index');
    Route::put('divisions/{division_id}', 'DivisionsController@update');

    Route::get('estimates', 'EstimatesController@index');
    Route::post('estimates', 'EstimatesController@store');
    Route::get('estimates/{estimate_id}', 'EstimatesController@show');
    Route::put('estimates/{estimate_id}', 'EstimatesController@update');

    Route::get('roles/{role_id}/system-permissions', 'RolesController@findSystemPermissions');
    Route::get('roles/{role_id}/boards-permissions', 'RolesController@findBoardsPermissions');
    Route::get('roles/{role_id}/columns-permissions', 'RolesController@findColumnsPermissions');
    Route::put('roles/{role_id}/columns-permissions', 'RolesController@updateColumnPermission');

    Route::post('roles/{role_id}/system-scope', 'RolesController@updateSystemScope');
    Route::post('roles/{role_id}/board-scope', 'RolesController@updateBoardScope');
    Route::post('roles/{role_id}/column-scope', 'RolesController@updateColumnScope');

    Route::get('permissions', 'PermissionsController@show');
    Route::post('permissions', 'PermissionsController@store');
    Route::delete('permissions', 'PermissionsController@delete');

    Route::get('settings', 'SettingsController@index');
    Route::put('settings', 'SettingsController@update');

    Route::get('phonebook', function () {
        return \App\Models\Core\Department::with('divisions.users.role')->get();
    });
});
