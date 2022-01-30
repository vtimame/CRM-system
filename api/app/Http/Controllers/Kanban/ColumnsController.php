<?php

namespace App\Http\Controllers\Kanban;

use App\Events\ColumnWasUpdated;
use App\Events\PermissionsWasChanged;
use App\Http\Controllers\Controller;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\User;
use App\Models\Kanban\Card\Member;
use App\Models\Kanban\CardThumbnail;
use App\Models\Kanban\Column;
use App\Services\ColumnService;
use App\Services\PermissionService;
use App\Services\ThumbnailService;
use Illuminate\Http\Request;

class ColumnsController extends Controller
{
    protected ColumnService $columnService;
    protected PermissionService $permissionService;
    protected ThumbnailService $thumbnailService;

    public function __construct(ColumnService $columnService, PermissionService $permissionService, ThumbnailService $thumbnailService)
    {
        $this->columnService = $columnService;
        $this->permissionService = $permissionService;
        $this->thumbnailService = $thumbnailService;
    }

    public function index(Request $request)
    {
        return $this->columnService->findByPermissions($request->user()->role_id);
    }

    public function rawIndex(Request $request)
    {
        return Column::with('board')->get();
    }

    public function store(Request $request)
    {
        $last_column = Column::orderBy('position', 'desc')->first();
        $position = $last_column->position + 1;
        $column = Column::create(array_merge($request->all(), [ 'position' => $position ]));

        $this->permissionService->addColumnScopes(
            $request->user()->role_id, $column->board_id, $column->id, config('oycrm.permissions.column.scope')
        );

        return Column::find($column->id);
    }

    public function update(string $column_id, Request $request)
    {
        $column = Column::find($column_id);
        $column->update($request->all());
        broadcast(new ColumnWasUpdated($column_id, $request->all()))->toOthers();
        return $request->all();
    }
}
