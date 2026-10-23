<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class RegistrationTest extends TestCase
{
    use RefreshDatabase;

    public function test_tourist_can_register_and_receive_an_authentication_token(): void
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Maria das Águas',
            'email' => 'maria@example.com',
            'password' => 'secret-pass',
            'profile_type' => 'turista',
            'travel_preferences' => ['interests' => ['natureza', 'cultura']],
        ]);

        $response
            ->assertCreated()
            ->assertJsonPath('user.name', 'Maria das Águas')
            ->assertJsonPath('user.email', 'maria@example.com')
            ->assertJsonPath('user.profile_type', 'turista')
            ->assertJsonMissingPath('user.password');

        $this->assertNotEmpty($response->json('token'));
        $this->assertDatabaseHas('users', [
            'email' => 'maria@example.com',
            'profile_type' => 'turista',
        ]);
        $this->assertDatabaseCount('tourist_profiles', 1);
        $this->assertDatabaseCount('personal_access_tokens', 1);
    }

    public function test_each_provider_specialty_can_register_with_pending_verification(): void
    {
        foreach (['barqueiro', 'guia', 'artesa', 'cozinheira'] as $profileType) {
            $response = $this->postJson('/api/register', [
                'name' => "Prestador {$profileType}",
                'email' => "{$profileType}@example.com",
                'password' => 'secret-pass',
                'profile_type' => $profileType,
                'phone' => '+5592999999999',
                'service_description' => 'Serviço comunitário especializado.',
                'professional_metadata' => ['experience_years' => 5],
            ]);

            $response
                ->assertCreated()
                ->assertJsonPath('user.profile_type', $profileType)
                ->assertJsonPath('user.verified', false)
                ->assertJsonMissingPath('user.password');

            $this->assertNotEmpty($response->json('token'));
            $this->assertDatabaseHas('provider_profiles', [
                'user_id' => $response->json('user.id'),
                'verified' => false,
            ]);
        }

        $this->assertDatabaseCount('provider_profiles', 4);
        $this->assertDatabaseCount('personal_access_tokens', 4);
    }

    public function test_registration_rejects_an_email_that_is_already_registered(): void
    {
        User::factory()->create(['email' => 'maria@example.com']);

        $this->postJson('/api/register', [
            'name' => 'Outra Maria',
            'email' => 'maria@example.com',
            'password' => 'secret-pass',
            'profile_type' => 'turista',
            'travel_preferences' => ['interests' => ['natureza']],
        ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['email']);

        $this->assertDatabaseCount('users', 1);
        $this->assertDatabaseCount('tourist_profiles', 0);
    }

    public function test_registration_rejects_an_unsupported_profile_without_creating_a_user(): void
    {
        $this->postJson('/api/register', [
            'name' => 'Perfil Inválido',
            'email' => 'invalid@example.com',
            'password' => 'secret-pass',
            'profile_type' => 'operador',
        ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['profile_type']);

        $this->assertDatabaseCount('users', 0);
        $this->assertDatabaseCount('provider_profiles', 0);
        $this->assertDatabaseCount('tourist_profiles', 0);
    }

    public function test_registration_requires_conditional_profile_fields(): void
    {
        $this->postJson('/api/register', [
            'name' => 'Turista sem preferências',
            'email' => 'turista@example.com',
            'password' => 'secret-pass',
            'profile_type' => 'turista',
        ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['travel_preferences']);

        $this->postJson('/api/register', [
            'name' => 'Guia sem dados',
            'email' => 'guia@example.com',
            'password' => 'secret-pass',
            'profile_type' => 'guia',
        ])
            ->assertUnprocessable()
            ->assertJsonValidationErrors([
                'phone',
                'service_description',
                'professional_metadata',
            ]);

        $this->assertDatabaseCount('users', 0);
    }
}
