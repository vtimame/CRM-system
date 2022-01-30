<?php


namespace App\Services;


use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Kanban\Column;
use Illuminate\Database\Eloquent\Collection;

class ColumnService
{
    /**
     * @param string $role_id
     * @param string $board_id
     * @return Collection
     */
    public function findByPermissions(string $role_id) : Collection
    {
        $permissions = ColumnPermission::where([['role_id', $role_id], ['scope', 'all', ['view_column']]])->get();
        return Column::orderBy('position')->find($permissions->pluck('column_id'));
    }
}
