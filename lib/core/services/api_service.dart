import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

sealed class LoginResult {
  const LoginResult();
}

class LoginAuthenticated extends LoginResult {
  const LoginAuthenticated({required this.user, required this.token});

  final Map<String, dynamic> user;
  final String token;
}

class LoginInvalidCredentials extends LoginResult {
  const LoginInvalidCredentials();
}

class LoginRequestFailure extends LoginResult {
  const LoginRequestFailure({required this.statusCode});

  final int statusCode;
}

class LoginNetworkFailure extends LoginResult {
  const LoginNetworkFailure();
}

enum UserProfileType {
  tourist('turista', 'Turista'),
  boatman('barqueiro', 'Barqueiro'),
  guide('guia', 'Guia'),
  artisan('artesa', 'Artesã'),
  cook('cozinheira', 'Cozinheira');

  const UserProfileType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  bool get isProvider => this != UserProfileType.tourist;

  static UserProfileType? fromApiValue(String value) {
    for (final profile in values) {
      if (profile.apiValue == value) {
        return profile;
      }
    }

    return null;
  }
}

class RegistrationRequest {
  const RegistrationRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.profileType,
    this.travelPreferences,
    this.phone,
    this.serviceDescription,
    this.professionalMetadata,
  });

  final String name;
  final String email;
  final String password;
  final UserProfileType profileType;
  final Map<String, dynamic>? travelPreferences;
  final String? phone;
  final String? serviceDescription;
  final Map<String, dynamic>? professionalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'profile_type': profileType.apiValue,
      if (travelPreferences != null) 'travel_preferences': travelPreferences,
      if (phone != null) 'phone': phone,
      if (serviceDescription != null) 'service_description': serviceDescription,
      if (professionalMetadata != null)
        'professional_metadata': professionalMetadata,
    };
  }
}

class RegisteredUser {
  const RegisteredUser({
    required this.id,
    required this.name,
    required this.email,
    required this.profileType,
    this.verified,
  });

  final int id;
  final String name;
  final String email;
  final UserProfileType profileType;
  final bool? verified;
}

sealed class RegistrationResult {
  const RegistrationResult();
}

class RegistrationAuthenticated extends RegistrationResult {
  const RegistrationAuthenticated({required this.user, required this.token});

  final RegisteredUser user;
  final String token;
}

class RegistrationValidationFailure extends RegistrationResult {
  const RegistrationValidationFailure({required this.fieldErrors});

  final Map<String, List<String>> fieldErrors;
}

class RegistrationRequestFailure extends RegistrationResult {
  const RegistrationRequestFailure({required this.statusCode});

  final int statusCode;
}

class RegistrationNetworkFailure extends RegistrationResult {
  const RegistrationNetworkFailure();
}

class ApiService {
  ApiService({
    http.Client? client,
    String? baseUrl,
    this._requestTimeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client(),
       _baseUrl = _normalizeBaseUrl(baseUrl ?? _environmentBaseUrl);

  static const String defaultBaseUrl = 'http://10.0.2.2:8000/api';
  static const String _environmentBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: defaultBaseUrl,
  );

  final http.Client _client;
  final String _baseUrl;
  final Duration _requestTimeout;

  Future<LoginResult> login(String email, String password) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final authenticated = _authenticatedResult(response.body);

        return authenticated ?? const LoginRequestFailure(statusCode: 200);
      }

      if (response.statusCode == 401) {
        return const LoginInvalidCredentials();
      }

      return LoginRequestFailure(statusCode: response.statusCode);
    } on TimeoutException {
      return const LoginNetworkFailure();
    } on http.ClientException {
      return const LoginNetworkFailure();
    } catch (_) {
      return const LoginNetworkFailure();
    }
  }

  Future<RegistrationResult> register(RegistrationRequest request) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/register'),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 201) {
        final authenticated = _registeredResult(response.body);

        return authenticated ??
            const RegistrationRequestFailure(statusCode: 201);
      }

      if (response.statusCode == 422) {
        final validationFailure = _validationFailure(response.body);

        return validationFailure ??
            const RegistrationRequestFailure(statusCode: 422);
      }

      return RegistrationRequestFailure(statusCode: response.statusCode);
    } on TimeoutException {
      return const RegistrationNetworkFailure();
    } on http.ClientException {
      return const RegistrationNetworkFailure();
    } catch (_) {
      return const RegistrationNetworkFailure();
    }
  }

  static LoginAuthenticated? _authenticatedResult(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final user = decoded['user'];
      final token = decoded['token'];

      if (user is! Map<String, dynamic> || token is! String || token.isEmpty) {
        return null;
      }

      return LoginAuthenticated(
        user: Map<String, dynamic>.from(user),
        token: token,
      );
    } on FormatException {
      return null;
    }
  }

  static RegistrationAuthenticated? _registeredResult(String responseBody) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final user = decoded['user'];
      final token = decoded['token'];

      if (user is! Map<String, dynamic> || token is! String || token.isEmpty) {
        return null;
      }

      final id = user['id'];
      final name = user['name'];
      final email = user['email'];
      final profileValue = user['profile_type'];
      final profileType = profileValue is String
          ? UserProfileType.fromApiValue(profileValue)
          : null;
      final verified = user['verified'];

      if (id is! num ||
          name is! String ||
          email is! String ||
          profileType == null ||
          (verified != null && verified is! bool)) {
        return null;
      }

      return RegistrationAuthenticated(
        user: RegisteredUser(
          id: id.toInt(),
          name: name,
          email: email,
          profileType: profileType,
          verified: verified as bool?,
        ),
        token: token,
      );
    } on FormatException {
      return null;
    }
  }

  static RegistrationValidationFailure? _validationFailure(
    String responseBody,
  ) {
    try {
      final decoded = jsonDecode(responseBody);

      if (decoded is! Map<String, dynamic> || decoded['errors'] is! Map) {
        return null;
      }

      final fieldErrors = <String, List<String>>{};

      for (final entry in (decoded['errors'] as Map).entries) {
        if (entry.key is! String || entry.value is! List) {
          return null;
        }

        final messages = entry.value.cast<dynamic>();

        if (messages.any((message) => message is! String)) {
          return null;
        }

        fieldErrors[entry.key as String] = messages.cast<String>();
      }

      return RegistrationValidationFailure(fieldErrors: fieldErrors);
    } on FormatException {
      return null;
    }
  }

  static String _normalizeBaseUrl(String value) {
    final normalized = value.trim().replaceFirst(RegExp(r'/+$'), '');

    return normalized.isEmpty ? defaultBaseUrl : normalized;
  }
}
