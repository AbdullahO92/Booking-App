<?php

namespace Database\Seeders;

use App\Models\City;
use App\Models\Governorate;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;


class CitySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
       $data=[
        'Damascus' =>['Damascus City','Mazah','Baramkeh'],
        'Rif Dimashq'=>['Mleiha','Douma','Harasta'],
        'Aleppo'=>['Aleppo City','Azaz','Albab'],
        'Homs'=>['Homs City','Ratan','Telbisa'],
        'Quneitra'=>['Masaada','Mashara','Tringa'],
        'Latakia'=>['Latakia City','Alhafa','slinfa'],
        'Tartus'=>['Tartus City','Banyas','Safita'],
        'Daraa'=>['Daraa City','Nuaa','Jasim'],
        'Raqqa'=>['Ean Eisaa','Almansora','Alamin'],
        'Der Al_Zor'=>['Der Al_Zor City','Albokamal','Alashara'],
        'Hasakah'=>['Hasakah City','Alkamishli','Amoda']
        ];
        foreach($data as $governorateName=>$cities){
            $governorate=Governorate::where('name',$governorateName)->first();
            if($governorate){
            foreach($cities as $city){
                City::create([
                    'name'=>$city,
                    'governorate_id'=>$governorate->id,
                ]);
            }}
        }
    }
}
