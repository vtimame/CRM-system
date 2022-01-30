<?php

namespace App\Http\Requests\Kanban\Card;

use Illuminate\Foundation\Http\FormRequest;

class UpdateAddress extends FormRequest
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
            'street' => 'nullable|min:3|string',
            'street_num' => 'nullable|string',
            'building' => 'nullable|string',
            'litera' => 'nullable|string',
            'floor' => 'nullable|string',
            'office' => 'nullable|string',
            'room_type' => 'nullable|string'
        ];
    }
}
