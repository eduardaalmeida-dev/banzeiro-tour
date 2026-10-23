import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class KeyValueStorage {
  Future<void> delete(String key);

  Future<String?> read(String key);

  Future<void> write({required String key, required String value});
}

class SecureKeyValueStorage implements KeyValueStorage {
  SecureKeyValueStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }
}

class AuthSession {
  AuthSession({KeyValueStorage? storage})
    : _storage = storage ?? SecureKeyValueStorage();

  static const _tokenKey = 'banzeiro_auth_token';

  final KeyValueStorage _storage;

  Future<void> clearToken() => _storage.delete(_tokenKey);

  Future<String?> readToken() => _storage.read(_tokenKey);

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }
}
