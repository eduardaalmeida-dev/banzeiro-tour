import 'dart:convert';

import 'package:banzeiro_tour/core/services/api_service.dart';
import 'package:banzeiro_tour/presentation/auth/views/login_view.dart';
import 'package:banzeiro_tour/presentation/auth/views/registration_view.dart';
import 'package:banzeiro_tour/presentation/provider/views/guide_panel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('opens the registration flow from login', (tester) async {
    await tester.pumpWidget(
      _loginApp(
        ApiService(client: MockClient((_) async => _successResponse())),
      ),
    );

    await tester.tap(find.byKey(const Key('login-register')));
    await tester.pumpAndSettle();

    expect(find.byType(RegistrationView), findsOneWidget);
  });

  testWidgets('shows a welcome message after a successful login', (
    tester,
  ) async {
    await tester.pumpWidget(
      _loginApp(
        ApiService(client: MockClient((_) async => _successResponse())),
      ),
    );

    await _submitLogin(tester);

    expect(find.text('Bem-vindo, Maria!'), findsOneWidget);
  });

  testWidgets('opens the matching panel when login includes a profile', (
    tester,
  ) async {
    await tester.pumpWidget(
      _loginApp(
        ApiService(
          client: MockClient(
            (_) async => _successResponse(profileType: 'guia'),
          ),
        ),
      ),
    );

    await _submitLogin(tester);

    expect(find.byType(GuidePanelPage), findsOneWidget);
  });

  testWidgets('shows an invalid credentials message for HTTP 401', (
    tester,
  ) async {
    await tester.pumpWidget(
      _loginApp(
        ApiService(client: MockClient((_) async => http.Response('{}', 401))),
      ),
    );

    await _submitLogin(tester);

    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
  });

  testWidgets('shows a connection message when the server is unreachable', (
    tester,
  ) async {
    await tester.pumpWidget(
      _loginApp(
        ApiService(
          client: MockClient((_) async {
            throw http.ClientException('Network unavailable');
          }),
        ),
      ),
    );

    await _submitLogin(tester);

    expect(
      find.text('Não foi possível conectar ao servidor. Tente novamente.'),
      findsOneWidget,
    );
  });

  testWidgets('shows a service failure message for non-auth API errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      _loginApp(
        ApiService(client: MockClient((_) async => http.Response('{}', 422))),
      ),
    );

    await _submitLogin(tester);

    expect(
      find.text('Não foi possível concluir o login. Tente novamente.'),
      findsOneWidget,
    );
  });
}

Widget _loginApp(ApiService apiService) {
  return MaterialApp(home: LoginView(apiService: apiService));
}

Future<void> _submitLogin(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('login-email')),
    'maria@example.com',
  );
  await tester.enterText(find.byKey(const Key('login-password')), 'secret');
  await tester.tap(find.byKey(const Key('login-submit')));
  await tester.pumpAndSettle();
}

http.Response _successResponse({String? profileType}) {
  final user = <String, dynamic>{
    'id': 1,
    'name': 'Maria',
    'email': 'maria@example.com',
  };

  if (profileType != null) {
    user['profile_type'] = profileType;
  }

  return http.Response(jsonEncode({'user': user, 'token': 'token-value'}), 200);
}
