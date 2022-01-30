<?php

namespace App\Models\Kanban;

use Jenssegers\Mongodb\Eloquent\Model;
use Jenssegers\Mongodb\Eloquent\SoftDeletes;

class Column extends Model
{
    use SoftDeletes;

    protected $collection = 'kanban_columns';
    protected $guarded = [];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function cards()
    {
        return $this->hasMany(Card::class, 'column_id', '_id')->orderBy('position');
    }

    public function board()
    {
        return $this->belongsTo(Board::class, 'board_id', '_id');
    }

    public function cards_count()
    {
        return count(Card::where('column_id', $this->_id)->get());
    }
}
