<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ProfileRelationshipTest extends TestCase
{
    use RefreshDatabase;

    public function test_tourist_user_has_a_tourist_profile(): void
    {
        $user = User::factory()->create(['profile_type' => 'turista']);
        $touristProfile = $user->touristProfile()->create([
            'travel_preferences' => ['interests' => ['natureza']],
        ]);

        $this->assertTrue($user->fresh()->touristProfile->is($touristProfile));
        $this->assertSame(['interests' => ['natureza']], $touristProfile->travel_preferences);
    }

    public function test_each_provider_specialty_has_a_provider_profile(): void
    {
        foreach (['barqueiro', 'guia', 'artesa', 'cozinheira'] as $profileType) {
            $user = User::factory()->create(['profile_type' => $profileType]);
            $providerProfile = $user->providerProfile()->create([
                'phone' => '+5592999999999',
                'service_description' => 'Serviço comunitário especializado.',
                'professional_metadata' => ['experience_years' => 5],
            ]);

            $this->assertTrue($user->fresh()->providerProfile->is($providerProfile));
            $this->assertFalse($providerProfile->verified);
        }

        $this->assertDatabaseCount('provider_profiles', 4);
    }
}
