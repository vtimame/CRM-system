<?php

namespace App\Http\Requests\Kanban;

use Illuminate\Foundation\Http\FormRequest;

class UpdateCardRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'title' => 'nullable|min:3|string',
            'description' => 'nullable|min:3|string',
            'position' => 'nullable|integer',
            'column_id' => 'nullable|integer',
            'board_id' => 'nullable|integer',
            'cover_id' => 'nullable|integer',
            'creator_id' => 'nullable|integer',
            'lead_id' => 'nullable|integer',
            'manager_profile_id' => 'nullable|integer',
            'exploring_profile_id' => 'nullable|integer',
            'requisites_id' => 'nullable|integer',
            'exploring_date' => 'nullable|date',
            'exploring_date_wish' => 'nullable|date',
            'installation_date' => 'nullable|date',
            'installation_date_wish' => 'nullable|date',
            'building_date' => 'nullable|date',
            'building_date_wish' => 'nullable|date',
            'is_private' => 'nullable|boolean',
            'is_archived' => 'nullable|boolean',
        ];
    }
}
