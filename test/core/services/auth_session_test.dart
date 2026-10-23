import 'package:banzeiro_tour/core/services/auth_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stores, reads, and clears the Sanctum token', () async {
    final storage = _FakeKeyValueStorage();
    final session = AuthSession(storage: storage);

    await session.saveToken('sanctum-token');

    expect(await session.readToken(), 'sanctum-token');
    expect(storage.values, {'banzeiro_auth_token': 'sanctum-token'});

    await session.clearToken();

    expect(await session.readToken(), isNull);
    expect(storage.values, isEmpty);
  });
}

class _FakeKeyValueStorage implements KeyValueStorage {
  final Map<String, String> values = {};

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}
