<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
// use Illuminate\Types\Relations\Role;
use Illuminate\Support\Facades\Validator;
class AuthController extends Controller
{
    public function register(Request $request){

//        $request->validate([
//
//       ] );
        $validator = Validator::make($request->all(), [
            'phone'=>'required|string|unique:users,phone',
            'role'=>'required|in:owner,tenant',
            'password'=>'required|string|min:8',
            'first_name'=>'required|string',
            'last_name'=>'required|string',
            'birth_date'=>'required|date',
            'user_image'=>'required|image',
            'id_image'=>'required|image'
        ]);

        if ($validator->fails()) {
            $error = $validator->errors()->first();

            return response()->json([
                'message'=>'error',
                'cause'=>$error,
            ]);
        }

        $userImagepath=$request->file('user_image')->store('user_images','public');
        $idImagepath=$request->file('id_image')->store('id_images','public');

       $user=User::create([
        'phone'=>$request->phone,
        'role'=>$request->role,
        'status'=>'pending',
        'password'=>Hash::make($request->password),
        'first_name'=>$request->first_name,
        'last_name'=>$request->last_name,
        'birth_date'=>$request->birth_date,
        'user_image'=>$userImagepath,
        'id_image'=>$idImagepath,
       ]);
       return response()->json([
       'message'=>'Registered successfully . Waiting admin approval',
       'user'=>$user,]);
    }

    public function login(Request $request){
        $request->validate([
             'phone'=>'required|string',
             'password'=>'required|string'
        ]);
        $user=User::where('phone',$request->phone)->first();
         if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message'=>'Invalid credentials'
            ],401);
        }
        if ($user->role !== 'admin' && $user->status !== 'approved') {
            return response()->json([
                'message' => 'Your account is not approved yet by the admin.',
                'status'  => $user->status
            ], 403);
        }
        $token=$user->createToken('auth_token')->plainTextToken;
        return response()->json([
            'message'=>'logged in successfully',
            'token'=>$token,
            'user'=>$user

        ]);
    }
      public function adminLogin(Request $request)
    {
        $request->validate([
            'phone'    => 'required|string',
            'password' => 'required|string'
        ]);

        $admin = User::where('phone', $request->phone)
                     ->where('role', 'admin')
                     ->first();

        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return response()->json([
                'message' => 'Invalid admin credentials'
            ], 401);
        }

        //haposha-> Admin always allowed to login
        $token = $admin->createToken('admin_token')->plainTextToken;

        return response()->json([
            'message' => 'Admin logged in successfully',
            'token'   => $token,
            'user'    => $admin
        ]);
    }

   // tokens->delete()= its mean that the user logged out form all devices
    public function logout(Request $request){
        $request->user()->currentAccessToken()->delete();
        return response()->json([
            'message'=>'logged out successfully'
        ]);

    }

}

