<?php

namespace Database\Seeders;

use App\Models\ProviderProfile;
use Illuminate\Database\Seeder;

class ProviderProfileSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        ProviderProfile::factory()->count(5)->create();
    }
}
