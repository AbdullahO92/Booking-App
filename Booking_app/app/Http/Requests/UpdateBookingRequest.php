<?php

namespace App\Http\Requests;

use App\Models\Booking;
use Illuminate\Foundation\Http\FormRequest;

class UpdateBookingRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
        'from'=>'required|date',
        'to'=>'required|date|after:from'
        ];
    }

    public function withValidator($validator)
{
    $validator->after(function ($validator) {

        $booking = Booking::find($this->route('id'));

        if (!$booking) {
            return;
        }

        $from = $this->from;
        $to   = $this->to;
        $apartmentId = $booking->apartment_id;

        $conflictingBooking = Booking::where('apartment_id', $apartmentId)
            ->where('id', '!=', $booking->id)
            ->whereIn('status', ['approved'])
            ->where(function ($query) use ($from, $to) {
                $query->where('from', '<', $to)
                      ->where('to', '>', $from);
            })
            ->exists();

        if ($conflictingBooking) {
            $validator->errors()->add(
                'from',
                "This apartment is already booked from {$conflictingBooking->from} to {$conflictingBooking->to}. Please select a different date."
            );
        }
    });
}

}
