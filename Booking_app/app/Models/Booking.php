<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Booking extends Model
{
   protected $guarded = [];
   
    public function user() {
    return $this->belongsTo(User::class);
   }

   public function apartment() {
    return $this->belongsTo(Apartment::class);
   }

   public function rating() {
    return $this->hasOne(Rating::class);
   }


}
