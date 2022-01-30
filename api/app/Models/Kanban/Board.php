<?php

namespace App\Models\Kanban;

use Jenssegers\Mongodb\Eloquent\Model;

class Board extends Model
{
    protected $collection = 'kanban_boards';
    protected $guarded = [];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function columns()
    {
        return $this->hasMany(Column::class, 'board_id', '_id')->orderBy('position');
    }
}
