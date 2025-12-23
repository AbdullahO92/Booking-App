<?php

namespace Database\Seeders;

use App\Models\Governorate;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class GovernorateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
      $governorates=[
        'Damascus',
        'Rif Dimashq',
        'Aleppo',
        'Homs',
        'Quneitra',
        'Latakia',
        'Tartus',
        'Daraa',
        'Raqqa',
        'Der Al_Zor',
        'Hasakah'
      ];
      foreach($governorates as $name){
        Governorate::create(['name'=>$name]);
      }
    }
}
