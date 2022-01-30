<?php

namespace App\Models\Core;

use Jenssegers\Mongodb\Eloquent\Model;

/**
 * App\Models\Core\UserRole
 *
 * @property int $id
 * @property string $name
 * @property \Illuminate\Support\Carbon|null $created_at
 * @property \Illuminate\Support\Carbon|null $updated_at
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\UserRole newModelQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\UserRole newQuery()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\UserRole query()
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\UserRole whereCreatedAt($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\UserRole whereId($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\UserRole whereName($value)
 * @method static \Illuminate\Database\Eloquent\Builder|\App\Models\Core\UserRole whereUpdatedAt($value)
 * @mixin \Eloquent
 * @property-read \Illuminate\Database\Eloquent\Collection|\App\Models\Core\RolePermission[] $permissions
 * @property-read int|null $permissions_count
 * @property-read \Illuminate\Database\Eloquent\Collection|\App\Models\Kanban\BoardPermission[] $boardPermissions
 * @property-read int|null $board_permissions_count
 * @property-read \Illuminate\Database\Eloquent\Collection|\App\Models\Kanban\ColumnPermission[] $columnPermissions
 * @property-read int|null $column_permissions_count
 * @property-read \Illuminate\Database\Eloquent\Collection|\App\Models\Core\Permission[] $globalPermissions
 * @property-read int|null $global_permissions_count
 */
class UserRole extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'user_roles';
    protected $guarded = [];
}
