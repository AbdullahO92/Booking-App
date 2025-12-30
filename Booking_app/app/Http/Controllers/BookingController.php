<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use Illuminate\Http\Request;

class BookingController extends Controller
{
    public function addBooking(Request $request)
    {
        $request->validate([
            'apartment_id' => 'required|exists:apartments,id',
            'from' => 'required|date|after_or_equal:today',
            'to' => 'required|date|after:from',
        ]);

        $apartmentId = $request->apartment_id;
        $from = $request->from;
        $to = $request->to;
        $userId = $request->user()->id;

        // التحقق من عدم وجود حجز سابق لنفس المستخدم على نفس الشقة في نفس الفترة
        $userConflict = Booking::where('apartment_id', $apartmentId)
            ->where('user_id', $userId)
            ->whereIn('status', ['pending', 'approved'])
            ->where(function ($query) use ($from, $to) {
                $query->whereBetween('from', [$from, $to])
                    ->orWhereBetween('to', [$from, $to])
                    ->orWhere(function ($q) use ($from, $to) {
                        $q->where('from', '<=', $from)
                            ->where('to', '>=', $to);
                    });
            })
            ->exists();

        if ($userConflict) {
            return response()->json([
                'message' => 'لديك حجز سابق على هذه الشقة في نفس الفترة'
            ], 400);
        }

        // التحقق من عدم وجود حجز مقبول من مستأجر آخر
        $otherConflict = Booking::where('apartment_id', $apartmentId)
            ->where('status', 'approved')
            ->where(function ($query) use ($from, $to) {
                $query->whereBetween('from', [$from, $to])
                    ->orWhereBetween('to', [$from, $to])
                    ->orWhere(function ($q) use ($from, $to) {
                        $q->where('from', '<=', $from)
                            ->where('to', '>=', $to);
                    });
            })
            ->exists();

        if ($otherConflict) {
            return response()->json([
                'message' => 'الشقة محجوزة في هذه الفترة، يرجى اختيار تواريخ أخرى'
            ], 400);
        }

        $booking = Booking::create([
            'apartment_id' => $apartmentId,
            'user_id' => $userId,
            'from' => $from,
            'to' => $to,
            'status' => 'pending',
        ]);

        return response()->json($booking, 200);
    }

    public function cancelBooking(Request $request, $id)
    {
        $user = $request->user();
        $booking = Booking::findOrFail($id);

        if ($booking->user_id !== $user->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if (in_array($booking->status, ['rejected', 'cancelled'])) {
            return response()->json(['message' => 'هذا الحجز لا يمكن إلغاؤه'], 400);
        }

        if (now()->toDateString() >= $booking->from) {
            return response()->json(['message' => 'لا يمكن إلغاء الحجز بعد بدء موعده'], 400);
        }

        $booking->status = 'cancelled';
        $booking->save();

        return response()->json($booking, 200);
    }

    public function updateBooking(Request $request, $id)
    {
        $user = $request->user();
        $booking = Booking::findOrFail($id);

        if ($booking->user_id !== $user->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        if (!in_array($booking->status, ['pending', 'approved'])) {
            return response()->json(['message' => 'لا يمكن تعديل هذا الحجز'], 400);
        }

        if (now()->toDateString() >= $booking->from) {
            return response()->json(['message' => 'لا يمكن تعديل الحجز بعد بدء موعده'], 400);
        }

        $request->validate([
            'from' => 'required|date|after_or_equal:today',
            'to' => 'required|date|after:from',
        ]);

        $from = $request->from;
        $to = $request->to;

        // التحقق من عدم وجود تضارب مع حجوزات أخرى (باستثناء الحجز الحالي)
        $conflict = Booking::where('apartment_id', $booking->apartment_id)
            ->where('id', '!=', $booking->id)
            ->where('status', 'approved')
            ->where(function ($query) use ($from, $to) {
                $query->whereBetween('from', [$from, $to])
                    ->orWhereBetween('to', [$from, $to])
                    ->orWhere(function ($q) use ($from, $to) {
                        $q->where('from', '<=', $from)
                            ->where('to', '>=', $to);
                    });
            })
            ->exists();

        if ($conflict) {
            return response()->json([
                'message' => 'الشقة محجوزة في هذه الفترة، يرجى اختيار تواريخ أخرى'
            ], 400);
        }

        $newStatus = $booking->status === 'approved' ? 'pending' : $booking->status;

        $booking->update([
            'from' => $from,
            'to' => $to,
            'status' => $newStatus,
        ]);

        return response()->json($booking, 200);
    }

    // جلب التواريخ المحجوزة لشقة معينة
    public function getBookedDates($apartmentId)
    {
        $bookings = Booking::where('apartment_id', $apartmentId)
            ->where('status', 'approved')
            ->where('to', '>=', now()->toDateString())
            ->select('from', 'to')
            ->get();

        return response()->json($bookings);
    }
}
