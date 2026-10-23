<?php

namespace Database\Factories;

use App\Models\ProviderProfile;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ProviderProfile>
 */
class ProviderProfileFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory()->state([
                'profile_type' => $this->faker->randomElement([
                    'barqueiro',
                    'guia',
                    'artesa',
                    'cozinheira',
                ]),
            ]),
            'phone' => $this->faker->e164PhoneNumber(),
            'service_description' => $this->faker->sentence(),
            'professional_metadata' => [
                'experience_years' => $this->faker->numberBetween(1, 30),
            ],
            'verified' => false,
        ];
    }
}
