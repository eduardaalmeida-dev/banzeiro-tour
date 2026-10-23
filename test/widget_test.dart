import 'package:banzeiro_tour/main.dart';
import 'package:banzeiro_tour/presentation/provider/state/provider_catalog_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/provider_catalog_fakes.dart';

void main() {
  testWidgets('shows the login screen', (WidgetTester tester) async {
    final fakes = FakeProviderCatalogRepositories();
    final controller = ProviderCatalogController.withRepositories(fakes.value);
    await controller.initialize();
    await tester.pumpWidget(BanzeiroTourApp(catalogController: controller));

    expect(find.byKey(const Key('login-logo')), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
