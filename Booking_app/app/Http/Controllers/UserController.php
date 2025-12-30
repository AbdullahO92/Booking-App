<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    protected $table = 'users';

    // جلب حجوزات المستخدم مع بيانات الشقة
    public function getUserBookings($id)
    {
        $bookings = User::findOrFail($id)
            ->bookings()
            ->with(['apartment' => function ($query) {
                $query->with(['mainImage', 'governorate', 'city']);
            }])
            ->orderBy('created_at', 'desc')
            ->get();

        // تحويل البيانات لتضمين معلومات الشقة
        $bookings = $bookings->map(function ($booking) {
            $apartment = $booking->apartment;
            return [
                'id' => $booking->id,
                'apartment_id' => $booking->apartment_id,
                'user_id' => $booking->user_id,
                'from' => $booking->from,
                'to' => $booking->to,
                'status' => $booking->status,
                'created_at' => $booking->created_at,
                'updated_at' => $booking->updated_at,
                'apartment' => $apartment ? [
                    'id' => $apartment->id,
                    'title' => $apartment->title,
                    'description' => $apartment->description,
                    'price_per_day' => $apartment->price_per_day,
                    'rooms' => $apartment->rooms,
                    'area' => $apartment->area,
                    'main_image' => $apartment->mainImage ? $apartment->mainImage->url : null,
                    'governorate' => $apartment->governorate ? $apartment->governorate->name : null,
                    'city' => $apartment->city ? $apartment->city->name : null,
                ] : null,
            ];
        });

        return response()->json($bookings, 200);
    }

    // جلب طلبات الحجز المعلقة للمالك
    public function pendingBookings(Request $request)
    {
        $owner = $request->user();

        if ($owner->role !== 'owner') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $bookings = Booking::where('status', 'pending')
            ->whereHas('apartment', function ($q) use ($owner) {
                $q->where('owner_id', $owner->id);
            })
            ->with(['user', 'apartment.mainImage'])
            ->get();

        return response()->json($bookings);
    }

    // قبول حجز
    public function approve(Request $request, $id)
    {
        $owner = $request->user();
        $booking = Booking::findOrFail($id);

        if ($booking->apartment->owner_id !== $owner->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($booking->status !== 'pending') {
            return response()->json(['message' => 'Booking already processed'], 400);
        }

        $booking->status = 'approved';
        $booking->save();

        return response()->json([
            'message' => 'Booking approved successfully',
            'booking' => $booking
        ]);
    }

    // رفض حجز
    public function reject(Request $request, $id)
    {
        $owner = $request->user();
        $booking = Booking::findOrFail($id);

        if ($booking->apartment->owner_id !== $owner->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if ($booking->status !== 'pending') {
            return response()->json(['message' => 'Booking already processed'], 400);
        }

        $booking->status = 'rejected';
        $booking->save();

        return response()->json([
            'message' => 'Booking rejected successfully',
            'booking' => $booking
        ]);
    }
}
