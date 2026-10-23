<?php

namespace Database\Seeders;

use App\Models\TouristProfile;
use Illuminate\Database\Seeder;

class TouristProfileSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        TouristProfile::factory()->count(5)->create();
    }
}
