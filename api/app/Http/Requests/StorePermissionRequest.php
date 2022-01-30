<?php

namespace App\Http\Requests;

/**
 * Class StorePermissionRequest
 * @package App\Http\Requests
 * @property int role_id
 * @property string name
 * @property string data
 */
class StorePermissionRequest extends ApiRequest
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
            'role_id' => 'required|integer',
            'board_id' => 'nullable|integer',
            'column_id' => 'nullable|integer',
            'name' => 'required|string',
            'data' => 'nullable|json'
        ];
    }
}
