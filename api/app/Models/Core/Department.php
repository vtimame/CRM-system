<?php

namespace App\Models\Core;

use Jenssegers\Mongodb\Eloquent\Model;

/**
 * App\Models\Core\Department
 *
 * @property int $id
 * @property string $name
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Department newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Department newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Department query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Department whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Department whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Department whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Department whereUpdatedAt($value)
 * @mixin \Eloquent
 */
class Department extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'departments';
    protected $guarded = [];

    public function divisions()
    {
        return $this->hasMany(Division::class, 'department_id', '_id');
    }
}
