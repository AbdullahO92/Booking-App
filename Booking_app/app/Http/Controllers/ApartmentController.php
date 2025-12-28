<?php

namespace App\Http\Controllers;

use App\Http\Resources\ApartmentResource;
use App\Models\Apartment;
use App\Models\Apartment_Image;
use App\Services\ImageService;
use Illuminate\Http\Request;

class ApartmentController extends Controller
{
    protected $images;

    public function __construct(ImageService $images)
    {
        $this->images = $images;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'governorate_id' => 'required|exists:governorates,id',
            'city_id'        => 'required|exists:cities,id',
            'title'          => 'required|string|max:255',
            'description'    => 'required|string',
            'price_per_day'  => 'required|numeric|min:0',
            'rooms'          => 'required|integer|min:1',
            'area'           => 'required|integer|min:0',
            'images'         => 'required|array|min:1',
            'images.*'       => 'image|max:5120',
            'main_image_index' => 'nullable|integer|min:0'
        ]);

        // التحقق من عدم وجود شقة مكررة بنفس العنوان والموقع للمالك
        $existingApartment = Apartment::where('owner_id', $request->user()->id)
            ->where('title', $validated['title'])
            ->where('governorate_id', $validated['governorate_id'])
            ->where('city_id', $validated['city_id'])
            ->first();

        if ($existingApartment) {
            return response()->json([
                'message' => 'error',
                'cause' => 'لديك شقة بنفس العنوان في هذا الموقع'
            ], 422);
        }

        $apartment = Apartment::create([
            'owner_id'       => $request->user()->id,
            'governorate_id' => $validated['governorate_id'],
            'city_id'        => $validated['city_id'],
            'title'          => $validated['title'],
            'description'    => $validated['description'] ?? null,
            'price_per_day'  => $validated['price_per_day'],
            'rooms'          => $validated['rooms'],
            'status'         => 'pending',
            'area'           => $validated['area'] ?? null,
        ]);

        $paths = $this->images->uploadMultiple($request->images);

        foreach ($paths as $index => $path) {
            Apartment_Image::create([
                'apartment_id' => $apartment->id,
                'image_path' => $path,
                'is_main'    =>
                    (isset($validated['main_image_index']) && $validated['main_image_index'] == $index)
            ]);
        }

        return response()->json([
            'message' => 'Listing created successfully',
            'apartment' => new ApartmentResource($apartment)
        ]);
    }

    // عرض كل الشقق المتاحة
    public function index(Request $request)
    {
        $apartment = Apartment::with('mainImage', 'images', 'owner');

        if ($request->has('governorate_id')) {
            $apartment->where('governorate_id', $request->governorate_id);
        }

        if ($request->has('city_id')) {
            $apartment->where('city_id', $request->city_id);
        }

        if ($request->has('max_price')) {
            $apartment->where('price_per_day', '<=', $request->max_price);
        }

        if ($request->has('rooms')) {
            $apartment->where('rooms', '>=', $request->rooms);
        }

        $allapartment = $apartment->where('status', 'approved')->get();

        return ApartmentResource::collection($allapartment);
    }

    // شقق المالك
    public function myApartment(Request $request)
    {
        $apartment = Apartment::where('owner_id', $request->user()->id)
            ->with('images', 'mainImage')
            ->get();

        return ApartmentResource::collection($apartment);
    }

    // تفاصيل شقة واحدة
    public function show($id)
    {
        $apartment = Apartment::with('images', 'mainImage', 'owner')->findOrFail($id);
        return new ApartmentResource($apartment);
    }

    // تحديث شقة
    public function update(Request $request, $id)
    {
        $apartment = Apartment::where('owner_id', $request->user()->id)->findOrFail($id);

        $validated = $request->validate([
            'title'          => 'sometimes|string|max:255',
            'description'    => 'sometimes|string',
            'price_per_day'  => 'sometimes|numeric|min:0',
            'rooms'          => 'sometimes|integer|min:1',
            'area'           => 'sometimes|integer|min:0',
            'images'         => 'nullable|array',
            'images.*'       => 'image|max:5120',
            'main_image_index' => 'nullable|integer|min:0'
        ]);

        $apartment->update($validated);

        if ($request->has('images')) {
            $apartment->images()->delete();

            $paths = $this->images->uploadMultiple($request->images);

            foreach ($paths as $index => $path) {
                $apartment->images()->create([
                    'image_path' => $path,
                    'is_main'    =>
                        (isset($validated['main_image_index']) && $validated['main_image_index'] == $index)
                ]);
            }
        }

        return response()->json([
            'message' => 'Listing updated successfully',
            'listing' => new ApartmentResource($apartment)
        ]);
    }

    // حذف شقة
    public function destroy(Request $request, $id)
    {
        $apartment = Apartment::where('owner_id', $request->user()->id)->findOrFail($id);
        $apartment->delete();
        return response()->json([
            'message' => 'apartment deleted successfully'
        ]);
    }
}
