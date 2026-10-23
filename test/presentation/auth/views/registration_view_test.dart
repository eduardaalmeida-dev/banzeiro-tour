import 'dart:async';
import 'dart:convert';

import 'package:banzeiro_tour/core/services/api_service.dart';
import 'package:banzeiro_tour/core/services/auth_session.dart';
import 'package:banzeiro_tour/presentation/auth/views/registration_view.dart';
import 'package:banzeiro_tour/presentation/experience/views/tourist_explore_page.dart';
import 'package:banzeiro_tour/presentation/provider/views/guide_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('allows selecting every profile while keeping base fields', (
    tester,
  ) async {
    await tester.pumpWidget(_registrationApp());
    await _enterText(
      tester,
      find.byKey(const Key('registration-name')),
      'Maria das Águas',
    );
    await _enterText(
      tester,
      find.byKey(const Key('registration-email')),
      'maria@example.com',
    );
    await _enterText(
      tester,
      find.byKey(const Key('registration-password')),
      'secret-pass',
    );

    for (final profile in UserProfileType.values) {
      await tester.tap(find.byKey(Key('profile-${profile.apiValue}')));
      await tester.pump();

      expect(
        tester
            .widget<ChoiceChip>(find.byKey(Key('profile-${profile.apiValue}')))
            .selected,
        isTrue,
      );
    }

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('registration-name')))
          .controller!
          .text,
      'Maria das Águas',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('registration-email')))
          .controller!
          .text,
      'maria@example.com',
    );
  });

  for (final profile in UserProfileType.values) {
    testWidgets('${profile.label} blocks incomplete submissions', (
      tester,
    ) async {
      await tester.pumpWidget(_registrationApp());
      await _selectProfile(tester, profile);
      await _tapSubmit(tester);

      expect(
        find.text('Este campo é obrigatório.'),
        findsNWidgets(profile.isProvider ? 6 : 4),
      );
    });
  }

  testWidgets('submits a complete tourist registration', (tester) async {
    var requests = 0;
    final storage = _MemoryStorage();
    await tester.pumpWidget(
      _registrationApp(
        client: MockClient((request) async {
          requests += 1;
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['profile_type'], 'turista');
          expect(body['travel_preferences'], {'preferences': 'Trilhas'});
          return _registrationResponse(profileType: 'turista');
        }),
        session: AuthSession(storage: storage),
      ),
    );
    await _selectProfile(tester, UserProfileType.tourist);
    await _fillBaseFields(tester);
    await _enterText(
      tester,
      find.byKey(const Key('registration-travel-preferences')),
      'Trilhas',
    );

    await _tapSubmit(tester);
    await tester.pumpAndSettle();

    expect(requests, 1);
    expect(find.byType(TouristExplorePage), findsOneWidget);
    expect(storage.values['banzeiro_auth_token'], 'registration-token');
  });

  testWidgets('shows API validation errors next to their fields', (
    tester,
  ) async {
    await tester.pumpWidget(
      _registrationApp(
        client: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'errors': {
                'email': ['Este e-mail já está cadastrado.'],
              },
            }),
            422,
          ),
        ),
      ),
    );
    await _selectProfile(tester, UserProfileType.tourist);
    await _fillBaseFields(tester);
    await _enterText(
      tester,
      find.byKey(const Key('registration-travel-preferences')),
      'Trilhas',
    );

    await _tapSubmit(tester);
    await tester.pump();

    expect(find.text('Este e-mail já está cadastrado.'), findsOneWidget);
  });

  testWidgets('disables repeated submissions while registration is pending', (
    tester,
  ) async {
    final response = Completer<http.Response>();
    await tester.pumpWidget(
      _registrationApp(
        client: MockClient((_) => response.future),
        session: AuthSession(storage: _MemoryStorage()),
      ),
    );
    await _selectProfile(tester, UserProfileType.tourist);
    await _fillBaseFields(tester);
    await _enterText(
      tester,
      find.byKey(const Key('registration-travel-preferences')),
      'Trilhas',
    );

    await _tapSubmit(tester);
    await tester.pump();

    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('registration-submit')))
          .onPressed,
      isNull,
    );

    response.complete(_registrationResponse(profileType: 'turista'));
    await tester.pumpAndSettle();
  });

  testWidgets('shows a network failure message', (tester) async {
    await tester.pumpWidget(
      _registrationApp(
        client: MockClient((_) async {
          throw http.ClientException('Network unavailable');
        }),
      ),
    );
    await _selectProfile(tester, UserProfileType.tourist);
    await _fillBaseFields(tester);
    await _enterText(
      tester,
      find.byKey(const Key('registration-travel-preferences')),
      'Trilhas',
    );

    await _tapSubmit(tester);
    await tester.pump();

    expect(
      find.text('Não foi possível conectar ao servidor. Tente novamente.'),
      findsOneWidget,
    );
  });

  testWidgets('opens the contextual provider home after saving the session', (
    tester,
  ) async {
    final storage = _MemoryStorage();
    await tester.pumpWidget(
      _registrationApp(
        client: MockClient(
          (_) async =>
              _registrationResponse(profileType: 'guia', verified: false),
        ),
        session: AuthSession(storage: storage),
      ),
    );
    await _selectProfile(tester, UserProfileType.guide);
    await _fillBaseFields(tester);
    await _enterText(
      tester,
      find.byKey(const Key('registration-phone')),
      '+5592999999999',
    );
    await _enterText(
      tester,
      find.byKey(const Key('registration-service-description')),
      'Trilhas guiadas',
    );
    await _enterText(
      tester,
      find.byKey(const Key('registration-professional-metadata')),
      'Cinco anos de experiência',
    );

    await _tapSubmit(tester);
    await tester.pumpAndSettle();

    expect(find.byType(GuidePanelPage), findsOneWidget);
    expect(storage.values['banzeiro_auth_token'], 'registration-token');
  });
}

Widget _registrationApp({http.Client? client, AuthSession? session}) {
  return MaterialApp(
    home: RegistrationView(
      apiService: ApiService(
        client: client ?? MockClient((_) async => _registrationResponse()),
      ),
      session: session,
    ),
  );
}

Future<void> _selectProfile(
  WidgetTester tester,
  UserProfileType profile,
) async {
  await tester.tap(find.byKey(Key('profile-${profile.apiValue}')));
  await tester.pump();
}

Future<void> _fillBaseFields(WidgetTester tester) async {
  await _enterText(
    tester,
    find.byKey(const Key('registration-name')),
    'Maria das Águas',
  );
  await _enterText(
    tester,
    find.byKey(const Key('registration-email')),
    'maria@example.com',
  );
  await _enterText(
    tester,
    find.byKey(const Key('registration-password')),
    'secret-pass',
  );
}

Future<void> _enterText(WidgetTester tester, Finder field, String value) async {
  await tester.scrollUntilVisible(field, 200, scrollable: _formScrollable);
  await tester.enterText(field, value);
}

Future<void> _tapSubmit(WidgetTester tester) async {
  final submit = find.byKey(const Key('registration-submit'));
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump();
  await tester.drag(find.byType(ListView), const Offset(0, -800));
  await tester.pump();
  await tester.tap(submit);
  await tester.pump();
}

final _formScrollable = find.byType(Scrollable).first;

http.Response _registrationResponse({
  String profileType = 'turista',
  bool? verified,
}) {
  final user = <String, dynamic>{
    'id': 1,
    'name': 'Maria das Águas',
    'email': 'maria@example.com',
    'profile_type': profileType,
  };

  if (verified != null) {
    user['verified'] = verified;
  }

  return http.Response(
    jsonEncode({'user': user, 'token': 'registration-token'}),
    201,
  );
}

class _MemoryStorage implements KeyValueStorage {
  final values = <String, String>{};

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
