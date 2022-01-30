<?php

namespace App\Console\Commands\Permissions;

use App\Events\PermissionsWasChanged;
use App\Models\Core\UserRole;
use App\Services\PermissionService;
use Illuminate\Console\Command;

class SystemScopes extends Command
{
    protected $permissionService;
    protected $signature = 'permission:system-scope {--role_id=} {--name=} {--remove}';
    protected $description = 'Give or remove system permissions';

    public function __construct(PermissionService $permissionService)
    {
        parent::__construct();
        $this->permissionService = $permissionService;
    }

    public function handle()
    {
        foreach ($this->getRoles() as $role) {
            if ($this->option('remove')) $this->permissionService->removeSystemScopes($role->id, $this->getScope());
            else $this->permissionService->addSystemScopes($role->id, $this->getScope());
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

    protected function getScope()
    {
        return $this->option('name') ? [$this->option('name')] : config('oycrm.permissions.system.scope');
    }
}
