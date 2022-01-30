<?php

namespace App\Http\Controllers;

use App\Events\PermissionsWasChanged;
use App\Models\Core\Permissions\BoardPermission;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\Permissions\SystemPermission;
use App\Models\Core\UserRole;
use App\Services\PermissionService;
use Illuminate\Http\Request;

class RolesController extends Controller
{
    protected $permissionService;
    public function __construct(PermissionService $permissionService)
    {
        $this->permissionService = $permissionService;
    }

    public function index()
    {
        return UserRole::all();
    }

    public function findSystemPermissions(string $role_id, Request $request)
    {
        return SystemPermission::whereRoleId($role_id)->first();
    }

    public function findBoardsPermissions(string $role_id, Request $request)
    {
        $board_id = $request->get('board_id');
        return BoardPermission::where([
            ['role_id', $role_id], ['board_id', $board_id]
        ])->first();
    }

    public function findColumnsPermissions(string $role_id, Request $request)
    {
        return ColumnPermission::where([
            ['role_id', $role_id], ['board_id', $request->get('board_id')], ['column_id', $request->get('column_id')]
        ])->first();
    }

    public function updateSystemScope(string $role_id, Request $request)
    {
        if ((bool) $request->get('remove')) {
            $result = $this->permissionService->removeSystemScopes($role_id, $request->get('scope'));
        } else {
            $result = $this->permissionService->addSystemScopes($role_id, $request->get('scope'));
        }

        broadcast(new PermissionsWasChanged($role_id));
        return $result;
    }

    public function updateBoardScope(string $role_id, Request $request)
    {
        if ((bool) $request->get('remove')) {
            $result = $this->permissionService->removeBoardScopes(
                $role_id, $request->get('board_id'), $request->get('scope')
            );
        } else {
            $result = $this->permissionService->addBoardScopes(
                $role_id, $request->get('board_id'), $request->get('scope')
            );
        }

        broadcast(new PermissionsWasChanged($role_id));
        return $result;
    }

    public function updateColumnScope(string $role_id, Request $request)
    {
        if ((bool) $request->get('remove')) {
            $result = $this->permissionService->removeColumnScopes(
                $role_id, $request->get('board_id'), $request->get('column_id'), $request->get('scope')
            );
        } else {
            $result = $this->permissionService->addColumnScopes(
                $role_id, $request->get('board_id'), $request->get('column_id'), $request->get('scope')
            );
        }

        broadcast(new PermissionsWasChanged($role_id));
        return $result;
    }

    public function updateColumnPermission(string $role_id, Request $request)
    {
        $result =  $this->permissionService->updateColumnPermission($role_id, $request);
        broadcast(new PermissionsWasChanged($role_id));
        return $result;
    }
}
