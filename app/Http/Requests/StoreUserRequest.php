<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use App\Rules\Name;
use App\Models\User;

class StoreUserRequest extends FormRequest
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
                'Name'=> ['required',new Name],
                'Email'=> ['required','unique:App\Models\User,email'],
                'Country'=> 'required',
                'Gender'=> 'required',
                'Birthday'=> 'required',
                'Password'=> 'required|confirmed',
        ];
    }
}
