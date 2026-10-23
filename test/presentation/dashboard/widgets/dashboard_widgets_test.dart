import 'package:banzeiro_tour/presentation/dashboard/widgets/dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('quantity controls provide semantic labels and 44px targets', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuantityStepper(
            label: 'estoque',
            value: 5,
            onDecrease: () {},
            onIncrease: () {},
            decreaseKey: const Key('decrease'),
            increaseKey: const Key('increase'),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Diminuir estoque'), findsOneWidget);
    expect(find.bySemanticsLabel('Aumentar estoque'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('decrease'))),
      const Size(44, 44),
    );
    expect(
      tester.getSize(find.byKey(const Key('increase'))),
      const Size(44, 44),
    );
  });

  testWidgets('tourist navigation exposes the four required destinations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: TouristBottomNavigation(onItemSelected: (_) {}),
        ),
      ),
    );

    for (final label in ['Explorar', 'Passaporte', 'Meu Voucher', 'Perfil']) {
      expect(find.text(label), findsOneWidget);
    }

    expect(
      tester.getSize(find.byKey(const Key('tourist-nav-explore'))).height,
      greaterThanOrEqualTo(44),
    );
  });
}
