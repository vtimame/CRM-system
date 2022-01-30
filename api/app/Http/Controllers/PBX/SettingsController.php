<?php

namespace App\Http\Controllers\PBX;

use App\Http\Controllers\Controller;
use App\Models\Pbx\Settings;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index(Request $request)
    {
        return Settings::first();
    }

    public function update(Request $request)
    {
        $settings = Settings::first();
        if (!$settings) Settings::create($request->all());
        else $settings->update($request->all());
    }
}
