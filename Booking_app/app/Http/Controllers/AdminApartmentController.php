<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Resources\ApartmentResource;
use App\Models\Apartment;
use Illuminate\Http\Request;

class AdminApartmentController extends Controller
{
     public function pendingApartment(){
           $apartment = Apartment::where('status', 'pending')
                           ->with('owner', 'images', 'mainImage')
                           ->get();

      // return response()->json($apartment);
       return  ApartmentResource::collection($apartment);
      
    }
    ///approved apartment
    public function approvedApartment($id){

    $apartment = Apartment::findOrFail($id);

    if ($apartment->status !== 'pending') {
        return response()->json([
            'message' => 'This apartment is already processed'
        ], 400);
    }

    $apartment->status = 'approved';
    $apartment->save();

    return response()->json([
        'message' => 'Apartment approved successfully',
        'apartment' =>  new ApartmentResource($apartment)
    ]);
  
}
public function rejectedapartment($id){
     $apartment = Apartment::findOrFail($id);
      if ($apartment->status !== 'pending') {
        return response()->json([
            'message' => 'This apartment is already processed'
        ], 400);
    }
    $apartment->status = 'rejected';
    $apartment->save();
      return response()->json([
        'message' => 'Apartment rejected  successfully',
        'apartment' => new ApartmentResource($apartment)
    ]);
   
}

}
