<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Models\Core\Event;
use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Kanban\Column;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;

class ActionsController extends Controller
{
    public function index(Request $request) {
        $actions = [];
        $permissions = ColumnPermission::where([
            ['role_id', $request->user()->role_id],
        ])->get();

        foreach ($permissions as $permission) {
            if ($permission->view_calls != null) {
                $calls = $this->getActions($request, 'call', $permission->view_calls['value']);
                if (!empty($calls)) $actions = array_merge($actions, $calls);
            }
            if ($permission->view_meetings != null) {
                $meetings = $this->getActions($request, 'meeting', $permission->view_calls['value']);
                if (!empty($meetings)) $actions = array_merge($actions, $meetings);
            }
        }

        $sorted = collect($actions)->unique()->sortBy('event_dt');
        return $sorted->values()->all();
    }

    protected function getActions(Request $request, string $type, string $view_permission) {
        $time = new \DateTime();
        $conditions = [
            ['render_type', $type],
            ['event_dt', '>', $time->format('Y-m-d H:i')],
            ['status', 'waiting']
        ];

        switch ($view_permission) {
            case 'all':
                break;
            case 'initiator':
            default:
                $conditions[] = ['user_id', $request->user()->id];
                break;
        }

        return Arr::flatten(Event::where($conditions)->get());
    }
}
