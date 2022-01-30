<?php

namespace App\Models\Kanban\Card;

use App\Models\Core\User;
use Jenssegers\Mongodb\Eloquent\Model;

class ExploringProfile extends Model
{
    protected $collection = 'kanban_card_exploring_profiles';
    protected $guarded = [];

    protected $casts = [
        'room_plan' => 'boolean',
        '_220V' => 'boolean',
        'project_for_approval' => 'boolean',
        'employee_lists' => 'boolean',
        'guarantee_letters' => 'boolean',
        'updated_at' => 'datetime:d.m.Y H:i',
        'created_at' => 'datetime:d.m.Y H:i',
    ];

    protected $with = ['user'];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', '_id');
    }


}
