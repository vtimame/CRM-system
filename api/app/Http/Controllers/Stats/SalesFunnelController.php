<?php

namespace App\Http\Controllers\Stats;

use App\Http\Controllers\Controller;
use App\Models\Kanban\Card;
use Carbon\Carbon;
use Illuminate\Http\Request;

class SalesFunnelController extends Controller
{
    public function index(Request $request) {
        return Card::with('move_events')->whereBetween('created_at', [
            Carbon::parse($request->get('start')),
            Carbon::parse($request->get('end'))
        ])->get();
    }
}
