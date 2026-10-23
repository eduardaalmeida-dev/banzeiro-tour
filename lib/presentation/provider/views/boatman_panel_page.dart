import 'package:flutter/material.dart';

import '../../../core/theme/app_visual_identity.dart';
import '../../../domain/provider_catalog/models.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';
import '../state/provider_catalog_controller.dart';
import '../state/provider_catalog_scope.dart';
import 'catalog_forms/boat_trip_form_page.dart';

class BoatmanPanelPage extends StatelessWidget {
  const BoatmanPanelPage({super.key, this.controller});

  final ProviderCatalogController? controller;

  @override
  Widget build(BuildContext context) {
    final activeController =
        controller ?? ProviderCatalogScope.maybeOf(context);
    if (activeController == null) {
      return const ProviderPageScaffold(
        title: 'Painel do Barqueiro',
        body: UnavailableCatalogState(),
      );
    }
    return ListenableBuilder(
      listenable: activeController,
      builder: (context, _) => _BoatmanPanelBody(controller: activeController),
    );
  }
}

class _BoatmanPanelBody extends StatelessWidget {
  const _BoatmanPanelBody({required this.controller});

  final ProviderCatalogController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.boatTrips;
    if (state.status == ProviderCatalogStatus.loading) {
      return const ProviderPageScaffold(
        title: 'Painel do Barqueiro',
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == ProviderCatalogStatus.failure) {
      return ProviderPageScaffold(
        title: 'Painel do Barqueiro',
        body: CatalogErrorState(onRetry: controller.reload),
      );
    }

    final trips = state.items;
    final totalToReceive = trips.fold<double>(
      0,
      (total, trip) => total + trip.amountToReceive,
    );
    return ProviderPageScaffold(
      title: 'Painel do Barqueiro',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          PanelHeaderCard(
            color: AppVisualIdentity.boatmanBlue,
            darkColor: AppVisualIdentity.boatmanBlueDark,
            icon: Icons.directions_boat_filled_outlined,
            name: 'Seu Raimundo Nonato',
            subtitle: 'Voadeira Rio Negro II',
            detail: Row(
              children: [
                Expanded(
                  child: MetricTile(
                    icon: Icons.navigation_outlined,
                    label: 'Saídas hoje',
                    value: '${trips.length}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MetricTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'A receber',
                    value: _currency(totalToReceive),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          DashboardPrimaryButton(
            key: const Key('boatman-add-trip'),
            label: 'CADASTRAR NOVA SAÍDA DE BARCO',
            icon: Icons.add_rounded,
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => BoatTripFormPage(controller: controller),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Saídas Programadas',
            style: TextStyle(
              color: AppVisualIdentity.darkGreen,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (trips.isEmpty)
            const EmptyCatalogState(
              message: 'Nenhuma saída cadastrada. Cadastre a primeira viagem offline.',
            )
          else
            for (final trip in trips) ...[
              _BoatTripCard(trip: trip),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _BoatTripCard extends StatelessWidget {
  const _BoatTripCard({required this.trip});

  final BoatTrip trip;

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
                    trip.route,
                    style: const TextStyle(
                      color: AppVisualIdentity.darkGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${trip.boatName} • Partida ${trip.departureTime}',
                    style: const TextStyle(
                      color: AppVisualIdentity.mutedText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _currency(trip.pricePerSeat),
              style: const TextStyle(
                color: AppVisualIdentity.primaryGreen,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CapacityProgress(
          current: trip.currentBooked,
          capacity: trip.maxCapacity,
          label: 'vagas',
        ),
        const SizedBox(height: 14),
        DashboardOutlinedButton(
          key: Key('validate-voucher-${trip.id}'),
          label: 'Validar Voucher (QR Code)',
          icon: Icons.qr_code_scanner_rounded,
          onPressed: () =>
              showFeatureUnavailable(context, 'Validação de voucher'),
        ),
      ],
    ),
  );
}

String _currency(double value) =>
    'R\$ ${value.toStringAsFixed(value % 1 == 0 ? 0 : 2)}';

class EmptyCatalogState extends StatelessWidget {
  const EmptyCatalogState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => OperationCard(
    child: Row(
      children: [
        const Icon(
          Icons.cloud_off_outlined,
          color: AppVisualIdentity.primaryGreen,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: AppVisualIdentity.mutedText,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}

class CatalogErrorState extends StatelessWidget {
  const CatalogErrorState({super.key, required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 44),
          const SizedBox(height: 12),
          const Text('Não foi possível abrir o catálogo local.'),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    ),
  );
}

class UnavailableCatalogState extends StatelessWidget {
  const UnavailableCatalogState({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('O catálogo local ainda não foi inicializado.'));
}
