<?php

namespace App\Console\Commands\Permissions;

use App\Events\PermissionsWasChanged;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\UserRole;
use App\Models\Kanban\Board;
use App\Services\PermissionService;
use Illuminate\Console\Command;

class ColumnPermissions extends Command
{
    protected $permissionService;
    protected $signature = 'permission:column-permission {--role_id=} {--board_id=} {--column_id=} {--name=} {--value=} {--remove}';
    protected $description = 'Give or remove column permissions';

    public function __construct(PermissionService $permissionService)
    {
        parent::__construct();
        $this->permissionService = $permissionService;
    }

    public function handle()
    {
        if (!$this->option('value')) {
            $this->error('value is empty');
            dd();
        }
        if (!$this->option('name')) {
            $this->error('name is empty');
            dd();
        }
        foreach ($this->getRoles() as $role) {
            foreach ($this->getBoards() as $board) {
                $columns = [];

                if ($this->option('column_id')) {
                    foreach ($board->columns as $column) {
                        if ($column->id == $this->option('column_id')) {
                            $columns[] = $column;
                        }
                    }
                } else {
                    $columns = $board->columns;
                }

                foreach ($columns as $column) {
                    $permissions = ColumnPermission::where([
                        ['role_id', $role->id], ['board_id', $board->id], ['column_id', $column->id]
                    ])->first();

                    if ($this->option('remove')) {
                        $permissions->unset($this->option('name'));
                    }
                    else {
                        $permissions->update([
                            $this->option('name') => [
                                'value' => $this->option('value')
                            ]
                        ]);
                    }
                }
            }
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
}
