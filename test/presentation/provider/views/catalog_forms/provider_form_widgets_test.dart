import 'package:banzeiro_tour/presentation/provider/views/catalog_forms/provider_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'reusable catalog controls fit and expose active state on phone',
    (tester) async {
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(320, 720));
      var submitted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ProviderFormScaffold(
            title: 'Novo catálogo',
            submitLabel: 'CONFIRMAR',
            onSubmit: () => submitted = true,
            isSubmitting: false,
            body: Column(
              children: [
                CatalogTextField(
                  controller: TextEditingController(),
                  label: 'Nome',
                  icon: Icons.label_outline,
                ),
                const SizedBox(height: 12),
                CatalogChoicePills<String>(
                  label: 'Tipo',
                  value: 'A',
                  choices: const [
                    CatalogChoice(value: 'A', label: 'Opção A'),
                    CatalogChoice(value: 'B', label: 'Opção B'),
                  ],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 12),
                DashedActionCard(
                  label: 'Adicionar foto',
                  icon: Icons.camera_alt_outlined,
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                CatalogStepper(
                  label: 'Quantidade',
                  value: 1,
                  suffix: 'itens',
                  onDecrease: null,
                  onIncrease: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Opção A'), findsWidgets);
      expect(find.bySemanticsLabel('Opção B'), findsWidgets);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const Key('catalog-form-submit')));
      expect(submitted, isTrue);
    },
  );

  testWidgets('confirmation footer disables the submit action while saving', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProviderFormScaffold(
          title: 'Novo catálogo',
          submitLabel: 'CONFIRMAR',
          onSubmit: null,
          isSubmitting: true,
          body: SizedBox(),
        ),
      ),
    );

    final submit = tester.widget<FilledButton>(
      find.byKey(const Key('catalog-form-submit')),
    );
    expect(submit.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
