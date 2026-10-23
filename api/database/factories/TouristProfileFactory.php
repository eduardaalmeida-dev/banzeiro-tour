<?php

namespace Database\Factories;

use App\Models\TouristProfile;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<TouristProfile>
 */
class TouristProfileFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory()->state(['profile_type' => 'turista']),
            'travel_preferences' => [
                'interests' => [$this->faker->word()],
            ],
        ];
    }
}
