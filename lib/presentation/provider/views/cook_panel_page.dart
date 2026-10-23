import 'package:flutter/material.dart';

import '../../../core/theme/app_visual_identity.dart';
import '../../../domain/provider_catalog/models.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';
import '../state/provider_catalog_controller.dart';
import '../state/provider_catalog_scope.dart';
import 'boatman_panel_page.dart'
    show CatalogErrorState, EmptyCatalogState, UnavailableCatalogState;
import 'catalog_forms/meal_form_page.dart';

class CookPanelPage extends StatelessWidget {
  const CookPanelPage({super.key, this.controller});

  final ProviderCatalogController? controller;

  @override
  Widget build(BuildContext context) {
    final activeController =
        controller ?? ProviderCatalogScope.maybeOf(context);
    if (activeController == null) {
      return const ProviderPageScaffold(
        title: 'Painel da Cozinheira',
        body: UnavailableCatalogState(),
      );
    }
    return ListenableBuilder(
      listenable: activeController,
      builder: (context, _) => _CookPanelBody(controller: activeController),
    );
  }
}

class _CookPanelBody extends StatelessWidget {
  const _CookPanelBody({required this.controller});

  final ProviderCatalogController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.meals;
    if (state.status == ProviderCatalogStatus.loading) {
      return const ProviderPageScaffold(
        title: 'Painel da Cozinheira',
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == ProviderCatalogStatus.failure) {
      return ProviderPageScaffold(
        title: 'Painel da Cozinheira',
        body: CatalogErrorState(onRetry: controller.reload),
      );
    }
    final meals = state.items;
    final reservationSummary = meals.isEmpty
        ? 'Nenhuma refeição reservada no momento.'
        : '${meals.first.reservedPortions} porções reservadas para ${meals.first.dishName}';
    return ProviderPageScaffold(
      title: 'Painel da Cozinheira',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          PanelHeaderCard(
            color: AppVisualIdentity.cookTerracotta,
            darkColor: AppVisualIdentity.cookTerracottaDark,
            icon: Icons.restaurant_menu_outlined,
            name: 'Dona Antônia',
            subtitle: 'Cozinha Tradicional',
            detail: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.restaurant_outlined,
                    color: Colors.white,
                    size: 19,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      reservationSummary,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          DashboardPrimaryButton(
            key: const Key('cook-plan-menu'),
            label: 'PROGRAMAR REFEIÇÃO / CARDÁPIO',
            icon: Icons.add_rounded,
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => MealFormPage(controller: controller),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Cardápio de Hoje',
            style: TextStyle(
              color: AppVisualIdentity.darkGreen,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (meals.isEmpty)
            const EmptyCatalogState(
              message: 'Nenhuma refeição programada. Salve o primeiro cardápio offline.',
            )
          else
            for (final meal in meals) ...[
              _MealCard(meal: meal, controller: controller),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({required this.meal, required this.controller});

  final Meal meal;
  final ProviderCatalogController controller;

  @override
  Widget build(BuildContext context) => OperationCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.mealType.label.toUpperCase(),
                    style: const TextStyle(
                      color: AppVisualIdentity.primaryGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.dishName,
                    style: const TextStyle(
                      color: AppVisualIdentity.darkGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'R\$ ${meal.price.toStringAsFixed(meal.price % 1 == 0 ? 0 : 2)}',
              style: const TextStyle(
                color: AppVisualIdentity.primaryGreen,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.schedule_outlined,
              size: 14,
              color: AppVisualIdentity.mutedText,
            ),
            const SizedBox(width: 6),
            Text(
              meal.timeWindow,
              style: const TextStyle(
                color: AppVisualIdentity.mutedText,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        CapacityProgress(
          current: meal.reservedPortions,
          capacity: meal.maxPortions,
          label: 'pratos reservados',
          useWords: true,
        ),
        const SizedBox(height: 12),
        QuantityStepper(
          label: 'porções de ${meal.dishName}',
          value: meal.reservedPortions,
          valueKey: Key('meal-${meal.id}-quantity'),
          decreaseKey: Key('meal-${meal.id}-decrease'),
          increaseKey: Key('meal-${meal.id}-increase'),
          onDecrease: meal.reservedPortions == 0 || controller.isWriting
              ? null
              : () => controller.updateMealReservations(
                  meal.id,
                  meal.reservedPortions - 1,
                ),
          onIncrease:
              meal.reservedPortions == meal.maxPortions || controller.isWriting
              ? null
              : () => controller.updateMealReservations(
                  meal.id,
                  meal.reservedPortions + 1,
                ),
        ),
      ],
    ),
  );
}
