<?php

namespace App\Models\Core;

use Jenssegers\Mongodb\Eloquent\Model;

class FirebaseToken extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'firebase_tokens';
    protected $guarded = [];
}
