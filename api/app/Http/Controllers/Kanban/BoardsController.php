<?php

namespace App\Http\Controllers\Kanban;

use App\Events\BoardWasUpdated;
use App\Events\PermissionsWasChanged;
use App\Http\Controllers\Controller;
use App\Models\Kanban\Board;
use App\Services\BoardService;
use App\Services\ColumnService;
use App\Services\PermissionService;
use Illuminate\Http\Request;

class BoardsController extends Controller
{
    protected PermissionService $permissionService;
    protected BoardService $boardService;
    protected ColumnService $columnService;

    public function __construct(
        PermissionService $permissionService,
        BoardService $boardService,
        ColumnService $columnService
    )
    {
        $this->permissionService = $permissionService;
        $this->boardService = $boardService;
        $this->columnService = $columnService;
    }

    public function index(Request $request)
    {
        return $this->boardService->findByPermissions($request->user()->role_id);
    }

    public function rawIndex(Request $request)
    {
        return Board::all();
    }

    public function store(Request $request)
    {
        $board = Board::create($request->all());

        $this->permissionService->addBoardScopes(
            $request->user()->role_id, $board->id, config('oycrm.permissions.board.scope')
        );
        broadcast(new PermissionsWasChanged($request->user()->role_id));

        return Board::find($board->id);
    }

    public function update(string $board_id, Request $request)
    {
        $board = Board::find($board_id);
        $board->update($request->all());
        broadcast(new BoardWasUpdated($board_id, $request->all()))->toOthers();
        return $request->all();
    }
}
