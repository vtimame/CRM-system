<?php

namespace App\Http\Controllers;

use App\Events\PermissionsWasChanged;
use App\Http\Requests\StorePermissionRequest;
use App\Models\Core\Permission;
use Illuminate\Http\Request;

class PermissionsController extends Controller
{
    public function show(Request $request)
    {
        $conditions = $this->getConditions($request);
        return Permission::where($conditions)->get();
    }

    public function store(StorePermissionRequest $request)
    {
        Permission::updateOrCreate(
            $request->validated(),
            $request->validated()
        );
        broadcast(new PermissionsWasChanged($request->get('role_id')));
        return Permission::where($this->getConditions($request))->get();
    }

    public function delete(Request $request)
    {
        Permission::where($request->all())->delete();
        broadcast(new PermissionsWasChanged($request->get('role_id')));
        return Permission::where($this->getConditions($request))->get();
    }

    protected function getConditions(Request $request)
    {
        $role_id = $request->get('role_id');
        $board_id = $request->get('board_id');
        $column_id = $request->get('column_id');
        $conditions = [['role_id', $role_id]];
        if ($board_id != null) $conditions[] = ['board_id', $board_id];
        if ($column_id != null) $conditions[] = ['column_id', $column_id];
        return $conditions;
    }
}
