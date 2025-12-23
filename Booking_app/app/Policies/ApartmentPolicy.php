<?php

namespace App\Policies;

use Illuminate\Auth\Access\Response;
use App\Models\Apartment;
use App\Models\User;

class ApartmentPolicy
{
    
    public function viewAny(User $user): bool
    {
        return false;
    }

    
    public function view(User $user, Apartment $apartment): bool
    {
        return false;
    }

    public function create(User $user): bool
    {
        return false;
    }

    public function update(User $user, Apartment $apartment)
    {
        return $user->id === $apartment->owner_id;
    }

    public function delete(User $user, Apartment $apartment)
    {
        return $user->id === $apartment->owner_id;
    }
    

    public function restore(User $user, Apartment $apartment): bool
    {
        return false;
    }

   
    public function forceDelete(User $user, Apartment $apartment): bool
    {
        return false;
    }
}
