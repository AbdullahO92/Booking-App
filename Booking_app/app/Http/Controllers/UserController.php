<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\User;
use Illuminate\Http\Request;

class UserController extends Controller
{
    protected $table = 'users';
    public function getUserBookings ($id)
    {
        $bookings=User::findOrFail($id)->bookings;
        return response()->json($bookings, 200);
    }

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
            ->with(['user', 'apartment'])
            ->get();

        return response()->json($bookings);
    }

    public function approveBooking(Request $request, $id)
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

    public function rejectBooking(Request $request, $id)
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
