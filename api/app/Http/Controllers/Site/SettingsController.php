<?php

namespace App\Http\Controllers\Site;

use App\Http\Controllers\Controller;
use App\Models\Site\Settings;
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
        return $this->index($request);
    }
}
