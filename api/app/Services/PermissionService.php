<?php

namespace App\Services;

use App\Models\Core\Permissions\BoardPermission;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\Permissions\SystemPermission;
use Illuminate\Http\Request;

class PermissionService
{
    protected $permissions;

    public function addSystemScopes(string $role_id, $scope) {
        $this->loadSystemPermissions($role_id);
        $this->permissions->push('scope', $scope, true);
        return $this->permissions;
    }

    public function removeSystemScopes(string $role_id, $scope) {
        $this->loadSystemPermissions($role_id);
        $this->permissions->pull('scope', $scope);
        if (empty($this->permissions->scope)) $this->permissions->delete();
        return $this->permissions;
    }

    protected function loadSystemPermissions(string $role_id)
    {
        if (!$this->permissions = SystemPermission::where('role_id', $role_id)->first()) {
            $this->permissions = SystemPermission::create([
                'role_id' => $role_id,
                'scope' => []
            ]);
        }
    }

    public function addBoardScopes(string $role_id, string $board_id, $scope) {
        $this->loadBoardPermissions($role_id, $board_id);
        $this->permissions->push('scope', $scope, true);
        return $this->permissions;
    }

    public function removeBoardScopes(string $role_id, string $board_id, $scope) {
        $this->loadBoardPermissions($role_id, $board_id);
        $this->permissions->pull('scope', $scope);
        if (empty($this->permissions->scope)) $this->permissions->delete();
        return $this->permissions;
    }

    protected function loadBoardPermissions(string $role_id, string $board_id)
    {
        if (!$this->permissions = BoardPermission::where([
            ['role_id', $role_id], ['board_id', $board_id]
        ])->first()) {
            $this->permissions = BoardPermission::create([
                'role_id' => $role_id,
                'board_id' => $board_id,
                'scope' => []
            ]);
        }
    }

    /**
     * @param string $role_id
     * @param string $board_id
     * @param string $column_id
     * @param array $scope
     * @return mixed
     */
    public function addColumnScopes(string $role_id, string $board_id, string $column_id, array $scope) {
        $this->loadColumnPermissions($role_id, $board_id, $column_id);
        $this->permissions->push('scope', $scope, true);
        return $this->permissions;
    }

    public function removeColumnScopes($role_id, $board_id, $column_id, $scope) {
        $this->loadColumnPermissions($role_id, $board_id, $column_id);
        $this->permissions->pull('scope', $scope);
        if (empty($this->permissions->scope)) $this->permissions->delete();
        return $this->permissions;
    }

    protected function loadColumnPermissions($role_id, $board_id, $column_id)
    {
        if (!$this->permissions = ColumnPermission::where([
            ['role_id', $role_id], ['board_id', $board_id], ['column_id', $column_id]
        ])->first()) {
            $this->permissions = ColumnPermission::create([
                'role_id' => $role_id,
                'board_id' => $board_id,
                'column_id' => $column_id,
                'scope' => []
            ]);
        }
    }

    public function updateColumnPermission(string $role_id, Request $request)
    {
        $board_id = $request->get('board_id');
        $column_id = $request->get('column_id');
        $name = $request->get('name');
        $data = $request->get('data');

        $this->loadColumnPermissions($role_id, $board_id, $column_id);
        $this->permissions->update([
            $name => $data
        ]);

        return $this->permissions;
    }
}
