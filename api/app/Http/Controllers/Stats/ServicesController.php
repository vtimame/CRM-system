<?php

namespace App\Http\Controllers\Stats;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Kanban\Card;
use Carbon\Carbon;
use Illuminate\Http\Request;

class ServicesController extends Controller
{
    public function index(Request $request)
    {
        $board_id = $request->get('board_id');
        $column_id = $request->get('column_id');
        $start = $request->get('start');
        $end = $request->get('end');

        $events = Event::whereBetween('created_at', [
            Carbon::parse($start), Carbon::parse($end)
        ])->where([['new_column_id', $column_id]])->get();
        return Card::where('column_id', $column_id)->whereIn('_id', $events->pluck('card_id'))->get();
    }
}
