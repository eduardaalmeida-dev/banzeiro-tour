<?php

namespace App\Http\Requests;

use App\Models\User;
use Illuminate\Contracts\Validation\ValidationRule;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class RegisterUserRequest extends FormRequest
{
    public const TOURIST_PROFILE_TYPE = 'turista';

    /** @var list<string> */
    public const PROVIDER_PROFILE_TYPES = [
        'barqueiro',
        'guia',
        'artesa',
        'cozinheira',
    ];

    /** @var list<string> */
    public const PROFILE_TYPES = [
        self::TOURIST_PROFILE_TYPE,
        ...self::PROVIDER_PROFILE_TYPES,
    ];

    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique(User::class)],
            'password' => ['required', 'string', 'min:8'],
            'profile_type' => ['required', 'string', Rule::in(self::PROFILE_TYPES)],
            'travel_preferences' => [
                'exclude_unless:profile_type,'.self::TOURIST_PROFILE_TYPE,
                'required_if:profile_type,'.self::TOURIST_PROFILE_TYPE,
                'array',
                'min:1',
            ],
            'phone' => [
                'exclude_unless:profile_type,'.implode(',', self::PROVIDER_PROFILE_TYPES),
                'required_if:profile_type,'.implode(',', self::PROVIDER_PROFILE_TYPES),
                'string',
                'max:30',
            ],
            'service_description' => [
                'exclude_unless:profile_type,'.implode(',', self::PROVIDER_PROFILE_TYPES),
                'required_if:profile_type,'.implode(',', self::PROVIDER_PROFILE_TYPES),
                'string',
                'max:2000',
            ],
            'professional_metadata' => [
                'exclude_unless:profile_type,'.implode(',', self::PROVIDER_PROFILE_TYPES),
                'required_if:profile_type,'.implode(',', self::PROVIDER_PROFILE_TYPES),
                'array',
                'min:1',
            ],
        ];
    }
}
