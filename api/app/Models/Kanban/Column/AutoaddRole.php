<?php

namespace App\Models\Kanban\Column;

use Jenssegers\Mongodb\Eloquent\Model;

class AutoaddRole extends Model
{
    protected $collection = 'autoadd_roles';
    protected $guarded = [];
}
