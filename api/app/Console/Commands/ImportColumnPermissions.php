<?php

namespace App\Console\Commands;

use App\Models\Core\UserRole;
use App\Models\Kanban\Board;
use App\Models\Kanban\Column;
use App\Services\PermissionService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ImportColumnPermissions extends Command
{
    protected $signature = 'import:columns-permissions';
    protected $description = 'Import kanban columns permissions from yii database';

    protected $permissionService;

    public function __construct(PermissionService $permissionService)
    {
        parent::__construct();
        $this->permissionService = $permissionService;
    }

    public function handle()
    {
        $this->info($this->description);
        $permissions = DB::connection('yii')->table('tasks_permissions')->get();

        foreach ($permissions as $permission) {
            $permission_name = $this->getPermissionName($permission->type);
            if ($permission->flag != 'false' && $permission_name != '') {
                $scope = [$permission_name];

                if ($permission_name == 'edit_manager_profile') {
                    array_push($scope, 'view_manager_profile');
                } else if ($permission_name == 'edit_exploring_profile') {
                    array_push($scope, 'view_exploring_profile');
                }

                $role_id = $this->getRoleId($permission->role);
                $board_id = $this->getBoardId($permission->board);
                $column_id = $this->getColumnId($permission->list);

                if (!$role_id || !$board_id || !$column_id) continue;

                $this->permissionService->addColumnScopes(
                    $role_id,
                    $board_id,
                    $column_id,
                    array_merge($scope, ['view_column'])
                );
            }
        }
    }

    protected function getPermissionName(string $type): string
    {
        switch ($type) {
            case 'add_attachment':
                return 'add_card_attachments';
            case 'add_checklist':
                return 'add_card_checklists';
            case 'add_checklist_item':
                return 'add_card_checklist_checkboxes';
            case 'add_comment':
                return 'edit_card_description';
            case 'add_contact':
                return 'add_card_contacts';
            case 'add_members':
                return 'add_card_members';
            case 'card_add':
                return 'add_cards';
            case 'card_client_edit':
                return 'edit_card_clients';
            case 'card_client_view':
                return 'view_card_clients';
            case 'card_leave':
                return 'leave_from_card';
            case 'card_operator_edit':
                return 'edit_card_operators';
            case 'card_operator_view':
                return 'view_card_operators';
            case 'card_reset_lead':
                return 'set_card_lead';
            case 'card_unset_lead':
                return 'unset_card_lead';
            case 'change_checklist':
                return 'edit_card_checklists';
            case 'change_contact':
                return 'edit_card_contacts';
            case 'change_exploring_data':
                return 'edit_exploring_profile';
            case 'change_manager_data':
                return 'edit_manager_profile';
            case 'change_name':
                return 'edit_card_title';
            case 'change_req':
                return 'edit_card_requisites';
            case 'check_checklist_item':
                return 'check_card_checklist_checkboxes';
            case 'command_call_add':
                return 'add_card_calls';
            case 'command_meeting_add':
                return 'add_card_meetings';
            case 'create_private_card':
                return 'add_private_cards';
            case 'manage_card_address':
                return 'edit_card_address';
            case 'manage_card_cover':
                return 'edit_card_cover';
            case 'remove_attachment':
                return 'delete_card_attachments';
            case 'remove_checklist':
                return 'delete_card_checklists';
            case 'remove_contact':
                return 'delete_card_contacts';
            case 'remove_members':
                return 'delete_card_members';
            case 'view':
                return 'view_column';
            case 'view_checklist':
                return 'view_card_checklists';
            case 'view_private_card':
                return 'view_private_cards';
            default:
                return '';
        }
    }

    protected function getRoleId(?int $mysql_id)
    {
        $role = UserRole::where('id', $mysql_id)->first();
        return $role ? $role->_id : null;
    }

    protected function getBoardId(?int $mysql_id)
    {
        $board = Board::where('id', $mysql_id)->first();
        return $board ? $board->_id : null;
    }

    protected function getColumnId(?int $mysql_id)
    {
        $division = Column::where('id', $mysql_id)->first();
        return $division ? $division->_id : null;
    }
}
