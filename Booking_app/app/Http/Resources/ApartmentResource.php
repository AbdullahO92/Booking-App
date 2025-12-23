<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ApartmentResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'title'          => $this->title,
            'description'    => $this->description,
            'price_per_day'  => $this->price_per_day,
            'rooms'          => $this->rooms,
            'area'           => $this->area,
            'status'         => $this->status,

            'governorate_id' => $this->governorate_id,
            'city_id'        => $this->city_id,

            'owner' => [
                'id'         => $this->owner->id,
                'first_name' => $this->owner->first_name,
                'last_name'  => $this->owner->last_name,
                'phone'      => $this->owner->phone,
            ],

            'main_image' => $this->mainImage ? $this->mainImage->url : null,

            'images' => $this->images->map(function ($img) {
                return [
                    'id'  => $img->id,
                    'url' => $img->url,
                    'is_main' => $img->is_main,
                ];
            }),
        ];
    }
    }

