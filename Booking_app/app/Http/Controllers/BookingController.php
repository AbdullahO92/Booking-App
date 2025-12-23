<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreBookingRequest;
use App\Http\Requests\UpdateBookingRequest;
use App\Models\Booking;
use App\Models\User;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function addBooking (StoreBookingRequest $request)
    {
        $data = $request->validated();
        $data['user_id'] = $request->user()->id;
        $data['status'] = 'pending';
        $booking = Booking::create($data);       
        return response()->json($booking, 200);
    }

    public function cancelBooking (Request $request,$id)
    {
        $user = $request->user();
        $booking = Booking::findOrFail($id);

        if ($booking->user_id !== $user->id) {
            return response()->json([
                'message' => 'Unauthorized'
            ], 403);
        }

        if ($booking->status === 'rejected') {
            return response()->json([
                'message' => 'Rejected booking cannot be cancelled'
            ], 400);
        }

        if (now()->toDateString() >= $booking->from) {
            return response()->json([
                'message' => 'Cannot cancel booking after it has started'
            ], 400);
        }
        $booking->status = 'cancelled';
        $booking->save();
        return response()->json($booking, 200);
    }

    public function updateBooking (UpdateBookingRequest $request, $id)
    {
        $user = $request->user();
        $booking = Booking::findOrFail($id);

        if ($booking->user_id !== $user->id) {
            return response()->json([
                'message' => 'Unauthorized'
            ], 403);
        }

        if ($booking->status !== 'pending') {
            return response()->json([
                'message' => 'Only pending bookings can be updated'
            ], 400);
        }

        if (now()->toDateString() >= $booking->from) {
            return response()->json([
                'message' => 'Cannot update booking after it has started'
            ], 400);
        }


        $booking->update($request->validated());
        return response()->json($booking, 200);
    }


}
