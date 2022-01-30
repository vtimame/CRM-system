<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Kanban\Card\Checklist;
use Illuminate\Http\Request;

class ChecklistController extends Controller
{
    public function index(Request $request)
    {
        return Checklist::where('card_id', $request->get('card_id'))->get();
    }

    public function store(Request $request)
    {
        return Checklist::create($request->all());
    }

    public function update(string $id, Request $request) {
        Checklist::find($id)->update($request->all());
    }
}
