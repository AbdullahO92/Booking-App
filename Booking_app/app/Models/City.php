<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class City extends Model
{
  protected $fillable = [
    'governorate_id',
    'name'
  ];
  public function governorate(){
    return $this->belongsTo(Governorate::class);
  }
  public function apartment(){
    return $this->hasMany(Apartment::class);
  }
}
