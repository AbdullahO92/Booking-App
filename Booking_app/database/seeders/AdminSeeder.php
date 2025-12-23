<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;


class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        if(User::where('role','admin')->exists()){
            return;
        }
        User::create([
            'phone'=>'0993699546',
            'password'=>bcrypt('hiba12345'),
            'role'=>'admin',
            'status'=>'approved',
            'first_name'=>'Hiba',
            'last_name'=>'Alhamad',
            'birth_date'=>'2005-07-15',
            'user_image'=>'user_images/user.admin.jpg',
            'id_image'=>'id_images/id.admin.jpg'

        ]);

    }
}
