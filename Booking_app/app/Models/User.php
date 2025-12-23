<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
   use HasApiTokens,Notifiable;
    protected $fillable = [
        'phone',
        'role',
        'status',
        'first_name',
        'last_name',
        'user_image',
        'birth_date',
        'id_image', 
        'password',
    ];

   
    protected $hidden = [
        'password',
    ];
    protected $appends = [
        'user_image_url',
        'id_image_url'
    ];

    public function getUserImageUrlAttribute(){
     if (!$this->user_image) {
        return null;
    }

    return asset('storage/' . $this->user_image);
}

public function getIdImageUrlAttribute()
{
    if (!$this->id_image) {
        return null;
    }

    return asset('storage/' . $this->id_image);
}

    public function bookings(){
        return $this->hasMany(Booking::class);
    }

    // protected function casts(): array
    // {
    //     return [
    //        // 'email_verified_at' => 'datetime',
    //         'password' => 'hashed',
    //     ];
    // }

}
