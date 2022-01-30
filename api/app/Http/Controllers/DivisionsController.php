<?php

namespace App\Http\Controllers;

use App\Models\Core\Division;
use Illuminate\Http\Request;

class DivisionsController extends Controller
{
    public function index(Request $request)
    {
        return Division::all();
    }

    public function update(string $manager_id, Request $request)
    {
        Division::findOrFail($manager_id)->update($request->all());
        return Division::findOrFail($manager_id);
    }
}
