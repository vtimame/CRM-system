<?php

namespace App\Services;

use App\Models\Core\Permissions\ColumnPermission;
use App\Models\Core\User;
use App\Models\Kanban\Card\Member;
use App\Models\Kanban\Card;
use App\Models\Kanban\Column\AutoaddRole;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Auth;

class ThumbnailService
{
    public function updatePositions(int $column_id, int $start = 0, string $type = 'increment'): void
    {
        CardThumbnail::whereColumnId($column_id)
            ->orderBy('position')->get()->each(function ($el, $key) use ($start, $type) {
                if ($type == 'increment') {
                    if ($start >= $key) $el->position = $el->position + 1;
                }

                if ($type == 'decrement') {
                    if ($start > $key) $el->position = $el->position - 1;
                }
            });
    }

    public function updateMembers(CardThumbnail $thumbnail)
    {
        $card_id = $thumbnail->id;
        $column_id = $thumbnail->column_id;
        $not_in_delete = [$thumbnail->creator_id];
        $membersId = [];
        if ($thumbnail->lead_id != null) $not_in_delete[] = $thumbnail->lead_id;

        Member::whereCardId($card_id)->whereNotIn('user_id', $not_in_delete)->delete();
        $autoadd_roles = AutoaddRole::whereColumnId($column_id)->pluck('role_id');
        if (count($autoadd_roles) > 0) {
            $date = Carbon::now();
            $members = User::whereIn('role_id', $autoadd_roles)->get();
            $membersData = [];
            foreach ($members as $member) {
                $membersId[] = $member->id;
                $membersData[] = [
                    'card_id' => $card_id,
                    'user_id' => $member->id,
                    'created_at' => $date,
                    'updated_at' => $date
                ];
            }
            Member::insert($membersData);
        }

        return User::find(array_merge($not_in_delete, $membersId));
    }

    public function findByPermissions(Request $request)
    {
        $result = [];
        $columns = $request->get('columns');
        $loaded_cards = $request->get('loaded_cards');
        $board_id = $request->get('board_id');
        $user = $request->user();
        $offset = $request->has('offset') ? $request->get('offset') : 0;
        $limit = $request->has('limit') ? $request->get('limit') : 6;

        foreach ($columns as $column_id) {
            $permissions = ColumnPermission::where([
                ['role_id', $user->role_id],
                ['column_id', $column_id],
                ['board_id', $board_id],
            ])->first();

            if (isset($permissions->view_cards)) {
                $cards = [];
                $value = $permissions->view_cards['value'];
                $query = Card::where('column_id', $column_id)
                    ->with('address', 'contacts', 'manager_profile', 'exploring_profile', 'operator', 'client', 'attachments', 'checklists', 'cover')
                    ->offset($offset)->limit($limit)->orderBy('position');

                switch ($value) {
                    case 'all':
                        $cards = $query->get();
                        break;
                    case 'creator':
                        $cards = $query->whereCreatorId($user->_id)->get();
                        break;
                    case 'lead':
                        $cards = $query->whereLeadId($user->_id)->get();
                        break;
                    case 'member':
                        $cards = $query->where('members', 'all', [$user->_id])->get();
                        break;
                    case 'role_list':
                        $creators = User::whereIn('role_id', $permissions->view_cards['role_list'])->get()->pluck('id');
                        $cards = $query->whereIn('creator_id', $creators)->get();
                        break;
                    default:
                        break;
                }

                array_push($result, $cards);
            }
        }

        $result = Arr::collapse($result);
        return Arr::where($result, function ($card) use ($loaded_cards) {
            return !in_array($card->_id, $loaded_cards);
        });
    }
}
