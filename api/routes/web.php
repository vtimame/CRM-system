<?php

use Illuminate\Support\Facades\Route;

//Route::get('/fire', function () {
//    broadcast(new App\Events\ExampleEvent);
//});

Route::get('/{any}', 'ApplicationController@getView')->where('any', '.*');
