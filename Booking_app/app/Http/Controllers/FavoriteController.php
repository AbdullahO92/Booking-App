<?php

namespace App\Http\Controllers;

use App\Models\Favorite;
use Illuminate\Http\Request;

class FavoriteController extends Controller
{
    // جلب المفضلة
    public function index(Request $request)
    {
        $favorites = Favorite::where('user_id', $request->user()->id)
            ->with(['apartment' => function ($query) {
                $query->with(['mainImage', 'governorate', 'city']);
            }])
            ->get()
            ->pluck('apartment');

        return response()->json($favorites);
    }

    // إضافة للمفضلة
    public function store(Request $request)
    {
        $request->validate([
            'apartment_id' => 'required|exists:apartments,id',
        ]);

        $favorite = Favorite::firstOrCreate([
            'user_id' => $request->user()->id,
            'apartment_id' => $request->apartment_id,
        ]);

        return response()->json(['message' => 'Added to favorites'], 200);
    }

    // إزالة من المفضلة
    public function destroy(Request $request, $apartmentId)
    {
        Favorite::where('user_id', $request->user()->id)
            ->where('apartment_id', $apartmentId)
            ->delete();

        return response()->json(['message' => 'Removed from favorites'], 200);
    }

    // التحقق إذا الشقة في المفضلة
    public function check(Request $request, $apartmentId)
    {
        $exists = Favorite::where('user_id', $request->user()->id)
            ->where('apartment_id', $apartmentId)
            ->exists();

        return response()->json(['is_favorite' => $exists]);
    }
}
