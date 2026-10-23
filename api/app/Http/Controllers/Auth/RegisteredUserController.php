<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\RegisterUserRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;

class RegisteredUserController extends Controller
{
    public function store(RegisterUserRequest $request): JsonResponse
    {
        $validated = $request->validated();

        $registration = DB::transaction(function () use ($validated): array {
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'password' => $validated['password'],
                'profile_type' => $validated['profile_type'],
            ]);

            $verified = null;

            if ($validated['profile_type'] === RegisterUserRequest::TOURIST_PROFILE_TYPE) {
                $user->touristProfile()->create([
                    'travel_preferences' => $validated['travel_preferences'],
                ]);
            } else {
                $providerProfile = $user->providerProfile()->create([
                    'phone' => $validated['phone'],
                    'service_description' => $validated['service_description'],
                    'professional_metadata' => $validated['professional_metadata'],
                ]);

                $verified = $providerProfile->verified;
            }

            return [
                'user' => $user,
                'verified' => $verified,
                'token' => $user->createToken('banzeiro-tour-token')->plainTextToken,
            ];
        });

        $user = $registration['user'];

        $publicUser = [
            'id' => $user->id,
            'name' => $user->name,
            'email' => $user->email,
            'profile_type' => $user->profile_type,
        ];

        if ($registration['verified'] !== null) {
            $publicUser['verified'] = $registration['verified'];
        }

        return response()->json([
            'user' => $publicUser,
            'token' => $registration['token'],
        ], 201);
    }
}
