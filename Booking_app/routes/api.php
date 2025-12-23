<?php

use App\Http\Controllers\AdminApartmentController;
use App\Http\Controllers\AdminUserController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ApartmentController;
use App\Http\Controllers\BookingController;
use App\Http\Controllers\OwnerBookingController;
use App\Http\Controllers\UserController;
use App\Models\Apartment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Route::get('/user', function (Request $request) {
//     return $request->user();
// })->middleware('auth:sanctum');
//بدون مدلوير راوتات عامة
Route::post('/register',[AuthController::class,'register']);
Route::post('/login',[AuthController::class,'login']);
route::post('/admin/login',[AuthController::class,'adminLogin']);
//filter and display apartment
Route::get('/apartment',[ApartmentController::class,'index']);
 //details شقة وحدة
Route::get('/apartment/{id}',[ApartmentController::class,'show']);

Route::middleware('auth:sanctum')->group(function(){
    Route::get('/user', function (Request $request) {
    return $request->user();
});
    Route::delete('/logout',[AuthController::class,'logout']);
    //اضافة شقة
    Route::post('/apartment',[ApartmentController::class,'store']);
    //update
    Route::post('/apartment/{id}',[ApartmentController::class,'update']);
    //delete
    Route::delete('/apartment/{id}',[ApartmentController::class,'destroy']);
    //ownerapartment
    Route::get('/my_apartment',[ApartmentController::class,'myApartment']);
});


Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {

    
    Route::get('/admin/users/pending', [AdminUserController::class, 'pendingUsers']);

    
    Route::put('/admin/users/{id}/approve', [AdminUserController::class, 'approveUser']);

    
    Route::put('/admin/users/{id}/reject', [AdminUserController::class, 'rejectUser']);
    //جيب شقق قيد الانتظار
     Route::get('/admin/apartment/pending', [AdminApartmentController::class, 'pendingApartment']);

    // الموافقة
    Route::put('/admin/apartment/{id}/approve', [AdminApartmentController::class, 'approvedApartment']);

    // الرفض
    Route::put('/admin/apartment/{id}/reject', [AdminApartmentController::class, 'rejectedapartment']);

    //الحجوزات
    //قسم المستأجر
    //عرض جميع حجوزات المستخدم
    Route::get('user/{id}/bookings',[UserController::class,'getUserBookings']);
    //إضافة حجز مع عدم التضارب
    Route::post('/bookings',[BookingController::class,'addBooking']);
    //إلغاء حجز
    Route::put('/bookings/{id}/cancel',[BookingController::class,'cancelBooking']);
    //التعديل على حجز
    Route::put('/bookings/{id}/update',[BookingController::class,'updateBooking']);

    //قسم المؤجر
    //عرض الحجوزات قيد الانتظار
    Route::get('owner/bookings/pending', [UserController::class, 'pendingBookings']);
    //قبول الحجز
    Route::post('owner/bookings/{id}/approve', [UserController::class, 'approve']);
    //رفض الحجز
    Route::post('owner/bookings/{id}/reject', [UserController::class, 'reject']);

});


