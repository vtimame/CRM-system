<?php

namespace App\Http\Controllers\PBX\CRM;

use App\Http\Controllers\Controller;
use App\Models\Pbx\Contact;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class ContactsController extends Controller
{
    public function show(Request $request)
    {
        return Contact::where('phone', intval($request->get('phone')))->first();
    }

    public function store(Request $request)
    {
        Log::channel('pbx')->info(json_encode($request->all()));
        return $this->createContact($request);
    }

    protected function createContact(Request $request)
    {
        return Contact::create($request->all());
    }
}
