<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Apartment extends Model
{
    protected $fillable = [
        'owner_id',
        'governorate_id',
        'city_id',
        'title',
        'description',
        'price_per_day',
        'rooms',
       // 'owner_phone',
        'area',
        'status'
    ];
    public function owner(){
        return $this->belongsTo(User::class,'owner_id');
    }
     public function images(){
        return $this->hasMany(Apartment_Image::class);
    }
     public function governorate(){
        return $this->belongsTo(Governorate::class);
    }
     public function city(){
        return $this->belongsTo(City::class);
    }
    public function mainImage(){
        return $this->hasOne(Apartment_Image::class)->where('is_main',true);
    }
    public function bookings() {
        return $this->hasMany(Booking::class);
    }
    public function ratings() {
    return $this->hasMany(Rating::class);
    }
    public function averageRating() {
    return $this->ratings()->avg('rating');
    }

}
