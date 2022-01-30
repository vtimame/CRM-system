<?php

use Illuminate\Support\Facades\Route;

Route::get('login', 'LoginController@findUser');
Route::post('login', 'LoginController@login');
Route::get('/user', 'LoginController@user')->middleware('auth:sanctum');
Route::get('/user/qr', 'LoginController@generateQrData')->middleware('auth:sanctum');
Route::post('logout', 'LoginController@logout')->middleware('auth:sanctum');
