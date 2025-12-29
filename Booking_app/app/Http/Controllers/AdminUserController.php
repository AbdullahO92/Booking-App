<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\Apartment;
use App\Models\User;
use Illuminate\Http\Request;

class AdminUserController extends Controller
{
    // جلب المستخدمين المعلقين
    public function pendingUsers()
    {
        return User::where('status', 'pending')->get();
    }

    // جلب جميع المستخدمين (ما عدا Admin)
    public function allUsers()
    {
        return User::where('role', '!=', 'admin')
            ->orderBy('created_at', 'desc')
            ->get();
    }

    // قبول مستخدم
    public function approveUser($id)
    {
        $user = User::findOrFail($id);
        $user->status = 'approved';
        $user->save();

        return response()->json([
            'message' => 'User approved successfully',
            'user' => $user
        ]);
    }

    // رفض مستخدم
    public function rejectUser($id)
    {
        $user = User::findOrFail($id);
        $user->status = 'rejected';
        $user->save();

        return response()->json([
            'message' => 'User rejected',
            'user' => $user
        ]);
    }

    // حذف مستخدم
    public function deleteUser($id)
    {
        $user = User::findOrFail($id);

        // منع حذف Admin
        if ($user->role === 'admin') {
            return response()->json([
                'message' => 'Cannot delete admin user'
            ], 403);
        }

        // حذف شقق المستخدم إذا كان مالك
        if ($user->role === 'owner') {
            // حذف صور الشقق أولاً
            foreach ($user->apartments as $apartment) {
                $apartment->images()->delete();
            }
            // حذف الشقق
            $user->apartments()->delete();
        }

        // حذف حجوزات المستخدم
        $user->bookings()->delete();

        // حذف المستخدم
        $user->delete();

        return response()->json([
            'message' => 'User deleted successfully'
        ]);
    }
}
