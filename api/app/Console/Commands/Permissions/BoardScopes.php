<?php

namespace App\Console\Commands\Permissions;

use App\Events\PermissionsWasChanged;
use App\Models\Core\UserRole;
use App\Models\Kanban\Board;
use App\Services\PermissionService;
use Illuminate\Console\Command;

class BoardScopes extends Command
{
    protected $permissionService;
    protected $signature = 'permission:board-scope {--role_id=} {--board_id=} {--name=} {--remove}';
    protected $description = 'Give or remove board permissions';

    public function __construct(PermissionService $permissionService)
    {
        parent::__construct();
        $this->permissionService = $permissionService;
    }

    public function handle()
    {
        foreach ($this->getRoles() as $role) {
            foreach ($this->getBoards() as $board) {
                if ($this->option('remove')) {
                    $this->permissionService->removeBoardScopes($role->id, $board->id, $this->getScope());
                }
                else $this->permissionService->addBoardScopes($role->id, $board->id, $this->getScope());
            }
            broadcast(new PermissionsWasChanged($role->id));
        }
    }

    protected function getRoles()
    {
        if (!$this->option('role_id')) {
            return UserRole::all();
        } else {
            $role = UserRole::whereId($this->option('role_id'))->first();
            if (!$role) dd('Role not found');
            return [$role];
        }
    }

    protected function getBoards()
    {
        if (!$this->option('board_id')) {
            return Board::all();
        } else {
            $role = Board::whereId($this->option('board_id'))->first();
            if (!$role) dd('Board not found');
            return [$role];
        }
    }

    protected function getScope()
    {
        return $this->option('name') ? [$this->option('name')] : config('oycrm.permissions.board.scope');
    }
}
