<?php

namespace App\Http\Controllers\Stats;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use Carbon\Carbon;
use Illuminate\Http\Request;

class ManagerEventsController extends Controller
{
    public function index(Request $request)
    {
        $start = $request->get('start');
        $end = $request->get('end');

        return Event::with('card', 'user')
            ->whereBetween('created_at', [
                Carbon::parse($start),
                Carbon::parse($end)
            ])->whereIn('render_type', ['call', 'meeting'])->get();
    }
}
