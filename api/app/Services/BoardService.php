<?php

namespace App\Services;

use App\Models\Core\Permissions\BoardPermission;
use App\Models\Kanban\Board;

class BoardService
{
    public function findByPermissions(string $role_id)
    {
        $permissions = BoardPermission::where('role_id', $role_id)
            ->where('scope', 'all', ['view_board'])
            ->get();

        return Board::whereIn('_id', $permissions->pluck('board_id'))->orderBy('created_at')->get();
    }
}
