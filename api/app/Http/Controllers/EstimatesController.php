<?php

namespace App\Http\Controllers;

use App\Models\Core\Estimate;
use Illuminate\Http\Request;

class EstimatesController extends Controller
{
    public function index(Request $request)
    {
        return Estimate::all();
    }

    public function store(Request $request)
    {
        return Estimate::create($request->all());
    }

    public function show(string $estimate_id, Request $request)
    {
        return Estimate::findOrFail($estimate_id);
    }

    public function update(string $estimate_id, Request $request)
    {
        Estimate::findOrFail($estimate_id)->update($request->all());
        return Estimate::findOrFail($estimate_id);
    }
}
