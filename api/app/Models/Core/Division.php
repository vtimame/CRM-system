<?php

namespace App\Models\Core;

use Jenssegers\Mongodb\Eloquent\Model;

/**
 * App\Models\Core\Division
 *
 * @property int $id
 * @property int $department_id
 * @property string $name
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @property-read \App\Models\Core\Department|null $department
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division whereDepartmentId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\Division whereUpdatedAt($value)
 * @mixin \Eloquent
 */
class Division extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'divisions';
    protected $guarded = [];

    protected $with = [
        'department'
    ];

    public function department()
    {
        return $this->hasOne(Department::class, '_id', 'department_id');
    }

    public function users()
    {
        return $this->hasMany(User::class, 'division_id', '_id')->where('deleted_at', 'exists', false);
    }
}
