import 'package:banzeiro_tour/presentation/experience/views/tourist_explore_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('filters experiences by category and host name', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TouristExplorePage()));

    expect(
      find.text('Travessia dos Botos & Vivência Comunitária no Tumbira'),
      findsOneWidget,
    );
    expect(find.text('Trilha da Samaúma Milenar'), findsOneWidget);

    await tester.tap(find.byKey(const Key('category-trails')));
    await tester.pump();

    expect(find.text('Trilha da Samaúma Milenar'), findsOneWidget);
    expect(
      find.text('Travessia dos Botos & Vivência Comunitária no Tumbira'),
      findsNothing,
    );

    await tester.enterText(find.byKey(const Key('explore-search')), 'MARCOS');
    await tester.pump();

    expect(find.text('Trilha da Samaúma Milenar'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('explore-search')),
      'inexistente',
    );
    await tester.pump();

    expect(find.text('Nenhuma experiência encontrada'), findsOneWidget);
  });

  testWidgets('shows complete cards and navigation feedback', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: TouristExplorePage()));

    expect(find.text('RDS Rio Negro, AM'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Comunidade do Tumbira'), findsOneWidget);
    expect(find.text('Seu Raimundo Nonato'), findsOneWidget);
    expect(find.text('R\$ 120'), findsOneWidget);
    expect(find.text('42 avaliações'), findsOneWidget);
    expect(find.text('Meu Voucher'), findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image).first);
    expect(image.errorBuilder, isNotNull);

    await tester.tap(find.byKey(const Key('tourist-nav-passport')));
    await tester.pump();

    expect(find.text('Passaporte estará disponível em breve.'), findsOneWidget);
  });

  testWidgets('remains usable on compact and wide screens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: TouristExplorePage()));

    expect(
      tester
          .widget<ListView>(find.byKey(const Key('explore-category-list')))
          .scrollDirection,
      Axis.horizontal,
    );
    await tester.drag(
      find.byKey(const Key('explore-category-list')),
      const Offset(-180, 0),
    );
    await tester.pump();
    // The test binding will surface any layout overflow that occurs here.

    await tester.binding.setSurfaceSize(const Size(900, 844));
    await tester.pump();
    expect(find.text('RDS Rio Negro, AM'), findsOneWidget);
    // The test binding will surface any layout overflow that occurs here.
  });
}
