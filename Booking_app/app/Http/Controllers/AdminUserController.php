<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Apartment;
use App\Models\User;
use Illuminate\Http\Request;

class AdminUserController extends Controller
{
    public function pendingUsers(){
        return User::where('status','pending')->get();
    }
    public function approveUser($id){
        $user=User::findOrFail($id);
        $user->status='approved';
        $user->save();
        return response()->json([
            'message'=>'user approved successfully',
            'user'=>$user
        ]);
    }
    public function rejectUser($id){
        $user=User::findOrFail($id);
        $user->status='rejected';
        $user->save();
        return response()->json([
            'message'=>'user rejected ',
            'user'=>$user
        ]);
    }
    ////pending arpartment
    public function pendingApartment(){
           $apartment = Apartment::where('status', 'pending')
                           ->with('owner', 'images', 'mainImage')
                           ->get();

        return response()->json($apartment);
    }
    ///approved apartment
//     public function approvedApartment($id){

//     $apartment = Apartment::findOrFail($id);

//     if ($apartment->status !== 'pending') {
//         return response()->json([
//             'message' => 'This apartment is already processed'
//         ], 400);
//     }

//     $apartment->status = 'approved';
//     $apartment->save();

//     return response()->json([
//         'message' => 'Apartment approved successfully',
//         'apartment' => $apartment
//     ]);
// }
// public function rejectedapartment($id){
//      $apartment = Apartment::findOrFail($id);
//       if ($apartment->status !== 'pending') {
//         return response()->json([
//             'message' => 'This apartment is already processed'
//         ], 400);
//     }
//     $apartment->status = 'rejected';
//     $apartment->save();
//       return response()->json([
//         'message' => 'Apartment rejected  successfully',
//         'apartment' => $apartment
//     ]);
// }

    }