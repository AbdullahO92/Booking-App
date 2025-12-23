<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateApartmentRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
  public function authorize() {
     return true; 
    } 
public function rules() {
    return [
        'governorate_id'=>'sometimes|exists:governorates,id',
        'city_id'=>'sometimes|exists:cities,id',
        'title'=>'sometimes|string|max:255',
        'description'=>'sometimes|string',
        'price_per_day'=>'sometimes|numeric|min:0',
        'rooms'=>'sometimes|integer|min:1',
        'bathrooms'=>'sometimes|integer|min:0',
        'area'=>'sometimes|integer|min:0',
        'images'=>'nullable|array',
        'images.*'=>'image|max:5120',
        'main_image_index' => 'nullable|integer|min:0'
    ];
}
}
