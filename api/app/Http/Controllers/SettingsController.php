<?php

namespace App\Http\Controllers;

use App\Models\Core\Setting;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index(Request $request)
    {
        return Setting::first();
    }

    public function update(Request $request) {
        $settings = Setting::first();
        if (!$settings) return Setting::create($request->get('payload'));
        else {
            $settings->update($request->get('payload'));
            return Setting::first();
        }
    }
}
