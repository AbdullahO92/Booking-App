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

// Routes عامة بدون مصادقة
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/admin/login', [AuthController::class, 'adminLogin']);

// عرض الشقق (للجميع)
Route::get('/apartment', [ApartmentController::class, 'index']);
Route::get('/apartment/{id}', [ApartmentController::class, 'show']);

// Routes تحتاج مصادقة
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    Route::delete('/logout', [AuthController::class, 'logout']);

    // إدارة الشقق (للمالك)
    Route::post('/apartment', [ApartmentController::class, 'store']);
    Route::put('/apartment/{id}', [ApartmentController::class, 'update']);
    Route::delete('/apartment/{id}', [ApartmentController::class, 'destroy']);
    Route::get('/my_apartment', [ApartmentController::class, 'myApartment']);

    // الحجوزات - قسم المستأجر
    Route::get('user/{id}/bookings', [UserController::class, 'getUserBookings']);
    Route::post('/bookings', [BookingController::class, 'addBooking']);
    Route::put('/bookings/{id}/cancel', [BookingController::class, 'cancelBooking']);
    Route::put('/bookings/{id}/update', [BookingController::class, 'updateBooking']);

    // الحجوزات - قسم المالك
    Route::get('owner/bookings/pending', [UserController::class, 'pendingBookings']);
    Route::post('owner/bookings/{id}/approve', [UserController::class, 'approve']);
    Route::post('owner/bookings/{id}/reject', [UserController::class, 'reject']);
});

// Routes خاصة بالـ Admin
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    // إدارة المستخدمين
    Route::get('/admin/users/pending', [AdminUserController::class, 'pendingUsers']);
    Route::get('/admin/users/all', [AdminUserController::class, 'allUsers']);
    Route::put('/admin/users/{id}/approve', [AdminUserController::class, 'approveUser']);
    Route::put('/admin/users/{id}/reject', [AdminUserController::class, 'rejectUser']);
    Route::delete('/admin/users/{id}', [AdminUserController::class, 'deleteUser']);

    // إدارة الشقق
    Route::get('/admin/apartment/pending', [AdminApartmentController::class, 'pendingApartment']);
    Route::put('/admin/apartment/{id}/approve', [AdminApartmentController::class, 'approvedApartment']);
    Route::put('/admin/apartment/{id}/reject', [AdminApartmentController::class, 'rejectedapartment']);
});

// المفضلة
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/favorites', [\App\Http\Controllers\FavoriteController::class, 'index']);
    Route::post('/favorites', [\App\Http\Controllers\FavoriteController::class, 'store']);
    Route::delete('/favorites/{apartmentId}', [\App\Http\Controllers\FavoriteController::class, 'destroy']);
    Route::get('/favorites/check/{apartmentId}', [\App\Http\Controllers\FavoriteController::class, 'check']);
});
