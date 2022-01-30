<?php

namespace App\Http\Controllers\Kanban\Column;

use App\Http\Controllers\Controller;
use App\Models\Kanban\Column\AutoaddRole;
use Illuminate\Http\Request;

class AutoaddController extends Controller
{
    public function show(string $column_id, Request $request)
    {
        return AutoaddRole::whereColumnId($column_id)->get()->pluck('role_id');
    }

    public function store(string $column_id, Request $request)
    {
        return AutoaddRole::create([
            'column_id' => $column_id,
            'role_id' => $request->get('role_id')
        ]);
    }

    public function destroy(string $column_id, Request $request)
    {
        return AutoaddRole::whereRoleId($request->get('role_id'))
            ->whereColumnId($column_id)->delete();
    }
}
