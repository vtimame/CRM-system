<?php

namespace App\Http\Requests\Kanban\Card;

use Illuminate\Foundation\Http\FormRequest;

class StoreContactRequest extends FormRequest
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
            'name' => 'required|string',
            'surname' => 'nullable|string',
            'patronymic' => 'nullable|string',
            'email' => 'nullable|string',
            'position' => 'nullable|string',
            'phones.*.phone' => 'required|integer',
            'phones.*.additional' => 'nullable|integer',
        ];
    }
}
