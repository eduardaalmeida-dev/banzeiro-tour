import 'dart:convert';

import 'package:banzeiro_tour/core/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiService.login', () {
    test('uses the default emulator URL for login', () async {
      late http.Request capturedRequest;
      final service = ApiService(
        client: MockClient((request) async {
          capturedRequest = request;
          return _successResponse();
        }),
      );

      await service.login('maria@example.com', 'secret');

      expect(
        capturedRequest.url,
        Uri.parse('${ApiService.defaultBaseUrl}/login'),
      );
      expect(jsonDecode(capturedRequest.body), {
        'email': 'maria@example.com',
        'password': 'secret',
      });
    });

    test('uses a configured API URL without a duplicate slash', () async {
      late http.Request capturedRequest;
      final service = ApiService(
        baseUrl: 'https://api.example.com/api/',
        client: MockClient((request) async {
          capturedRequest = request;
          return _successResponse();
        }),
      );

      await service.login('maria@example.com', 'secret');

      expect(
        capturedRequest.url,
        Uri.parse('https://api.example.com/api/login'),
      );
    });

    test('returns an authenticated result for a valid response', () async {
      final service = ApiService(
        client: MockClient((_) async => _successResponse()),
      );

      final result = await service.login('maria@example.com', 'secret');

      expect(result, isA<LoginAuthenticated>());
      final authenticated = result as LoginAuthenticated;
      expect(authenticated.user['name'], 'Maria');
      expect(authenticated.token, 'token-value');
    });

    test('returns invalid credentials for HTTP 401', () async {
      final service = ApiService(
        client: MockClient((_) async => http.Response('{}', 401)),
      );

      final result = await service.login('maria@example.com', 'wrong');

      expect(result, isA<LoginInvalidCredentials>());
    });

    test(
      'returns a request failure for validation and server errors',
      () async {
        for (final statusCode in [422, 500]) {
          final service = ApiService(
            client: MockClient((_) async => http.Response('{}', statusCode)),
          );

          final result = await service.login('maria@example.com', 'secret');

          expect(result, isA<LoginRequestFailure>());
          expect((result as LoginRequestFailure).statusCode, statusCode);
        }
      },
    );

    test('returns a network failure when the HTTP client throws', () async {
      final service = ApiService(
        client: MockClient((_) async {
          throw http.ClientException('Network unavailable');
        }),
      );

      final result = await service.login('maria@example.com', 'secret');

      expect(result, isA<LoginNetworkFailure>());
    });
  });

  group('ApiService.register', () {
    test('sends a specialized registration request', () async {
      late http.Request capturedRequest;
      final service = ApiService(
        client: MockClient((request) async {
          capturedRequest = request;
          return _registrationSuccessResponse();
        }),
      );

      await service.register(
        const RegistrationRequest(
          name: 'Maria das Águas',
          email: 'maria@example.com',
          password: 'secret-pass',
          profileType: UserProfileType.tourist,
          travelPreferences: {
            'interests': ['natureza'],
          },
        ),
      );

      expect(
        capturedRequest.url,
        Uri.parse('${ApiService.defaultBaseUrl}/register'),
      );
      expect(capturedRequest.headers['content-type'], 'application/json');
      expect(jsonDecode(capturedRequest.body), {
        'name': 'Maria das Águas',
        'email': 'maria@example.com',
        'password': 'secret-pass',
        'profile_type': 'turista',
        'travel_preferences': {
          'interests': ['natureza'],
        },
      });
    });

    test('returns typed public registration data for HTTP 201', () async {
      final service = ApiService(
        client: MockClient((_) async => _registrationSuccessResponse()),
      );

      final result = await service.register(
        const RegistrationRequest(
          name: 'João Guia',
          email: 'joao@example.com',
          password: 'secret-pass',
          profileType: UserProfileType.guide,
          phone: '+5592999999999',
          serviceDescription: 'Guias de trilhas.',
          professionalMetadata: {'experience_years': 5},
        ),
      );

      expect(result, isA<RegistrationAuthenticated>());
      final authenticated = result as RegistrationAuthenticated;
      expect(authenticated.user.name, 'João Guia');
      expect(authenticated.user.profileType, UserProfileType.guide);
      expect(authenticated.user.verified, isFalse);
      expect(authenticated.token, 'registration-token');
    });

    test('returns field errors for HTTP 422', () async {
      final service = ApiService(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'message': 'The given data was invalid.',
              'errors': {
                'email': ['O e-mail já está em uso.'],
              },
            }),
            422,
          ),
        ),
      );

      final result = await service.register(_touristRegistrationRequest());

      expect(result, isA<RegistrationValidationFailure>());
      expect((result as RegistrationValidationFailure).fieldErrors, {
        'email': ['O e-mail já está em uso.'],
      });
    });

    test('returns a network failure when the HTTP client throws', () async {
      final service = ApiService(
        client: MockClient((_) async {
          throw http.ClientException('Network unavailable');
        }),
      );

      final result = await service.register(_touristRegistrationRequest());

      expect(result, isA<RegistrationNetworkFailure>());
    });
  });
}

http.Response _successResponse() {
  return http.Response(
    jsonEncode({
      'user': {'id': 1, 'name': 'Maria', 'email': 'maria@example.com'},
      'token': 'token-value',
    }),
    200,
  );
}

RegistrationRequest _touristRegistrationRequest() {
  return const RegistrationRequest(
    name: 'Maria das Águas',
    email: 'maria@example.com',
    password: 'secret-pass',
    profileType: UserProfileType.tourist,
    travelPreferences: {
      'interests': ['natureza'],
    },
  );
}

http.Response _registrationSuccessResponse() {
  return http.Response(
    jsonEncode({
      'user': {
        'id': 1,
        'name': 'João Guia',
        'email': 'joao@example.com',
        'profile_type': 'guia',
        'verified': false,
      },
      'token': 'registration-token',
    }),
    201,
  );
}
