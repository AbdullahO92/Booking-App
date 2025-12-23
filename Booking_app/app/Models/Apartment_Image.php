<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Apartment_Image extends Model
{
    protected $fillable = [
        'apartment_id',
        'image_path',
        'is_main'
    ];
     protected $appends = [
       'url'
    ];
    public function apartment(){
        return $this->belongsTo(Apartment::class);
    }
    public function getUrlAttribute(){
        return asset('storage/'.$this->image_path); 
    }
}
    

