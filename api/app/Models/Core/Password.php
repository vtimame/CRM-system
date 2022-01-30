<?php

namespace App\Models\Core;

use Illuminate\Support\Facades\Hash;
use Jenssegers\Mongodb\Eloquent\Model;

class Password extends Model
{
    protected $collection = 'passwords';
    protected $fillable = ['user_id', 'password'];
    public $timestamps = false;
}
