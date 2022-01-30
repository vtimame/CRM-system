<?php

namespace App\Http\Controllers\Kanban\Card;

use App\Http\Controllers\Controller;
use App\Models\Kanban\Card\Command;
use Carbon\Carbon;
use Illuminate\Http\Request;

class CommandsController extends Controller
{
    public function store(string $card_id, Request $request)
    {
        $command = Command::create(array_merge(
            $request->all(),
            [
                'card_id' => $card_id,
                'user_id' => $request->user()->id
            ]
        ));

        return Command::find($command->id);
    }

    public function update(string $card_id, Request $request)
    {
        Command::find($request->get('id'))->update($request->all());
        return Command::find($request->get('id'));
    }
}
