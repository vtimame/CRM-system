<?php

use Illuminate\Support\Facades\Route;

Route::get('salesFunnelCards', 'SalesFunnelController@index');
Route::get('servicesStats', 'ServicesController@index');
Route::get('managerEvents', 'ManagerEventsController@index');
