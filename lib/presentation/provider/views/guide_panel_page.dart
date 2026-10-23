import 'package:flutter/material.dart';

import '../../../core/theme/app_visual_identity.dart';
import '../../../domain/provider_catalog/models.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';
import '../state/provider_catalog_controller.dart';
import '../state/provider_catalog_scope.dart';
import 'boatman_panel_page.dart'
    show CatalogErrorState, EmptyCatalogState, UnavailableCatalogState;
import 'catalog_forms/trail_form_page.dart';

class GuidePanelPage extends StatelessWidget {
  const GuidePanelPage({super.key, this.controller});

  final ProviderCatalogController? controller;

  @override
  Widget build(BuildContext context) {
    final activeController =
        controller ?? ProviderCatalogScope.maybeOf(context);
    if (activeController == null) {
      return const ProviderPageScaffold(
        title: 'Painel do Guia',
        body: UnavailableCatalogState(),
      );
    }
    return ListenableBuilder(
      listenable: activeController,
      builder: (context, _) => _GuidePanelBody(controller: activeController),
    );
  }
}

class _GuidePanelBody extends StatelessWidget {
  const _GuidePanelBody({required this.controller});

  final ProviderCatalogController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.trails;
    if (state.status == ProviderCatalogStatus.loading) {
      return const ProviderPageScaffold(
        title: 'Painel do Guia',
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == ProviderCatalogStatus.failure) {
      return ProviderPageScaffold(
        title: 'Painel do Guia',
        body: CatalogErrorState(onRetry: controller.reload),
      );
    }
    final trails = state.items;
    final agenda = trails.isEmpty
        ? 'Nenhuma trilha publicada para a agenda.'
        : '${trails.first.name} — até ${trails.first.maxPeople} ecoturistas';
    return ProviderPageScaffold(
      title: 'Painel do Guia',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          PanelHeaderCard(
            color: AppVisualIdentity.guideForest,
            darkColor: AppVisualIdentity.guideForestDark,
            icon: Icons.explore_outlined,
            name: 'Jairo da Silva',
            subtitle: 'Guia Cadastur',
            detail: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_outlined,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'AGENDA ATIVA',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    agenda,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          DashboardPrimaryButton(
            key: const Key('guide-add-trail'),
            label: 'CADASTRAR NOVA TRILHA / VIVÊNCIA',
            icon: Icons.add_rounded,
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => TrailFormPage(controller: controller),
              ),
            ),
          ),
          const SizedBox(height: 10),
          DashboardOutlinedButton(
            key: const Key('guide-release-stamp'),
            label: 'Liberar Selo no Passaporte Verde',
            icon: Icons.workspace_premium_outlined,
            onPressed: () =>
                showFeatureUnavailable(context, 'Liberação de selo'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Trilhas Publicadas',
            style: TextStyle(
              color: AppVisualIdentity.darkGreen,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (trails.isEmpty)
            const EmptyCatalogState(
              message:
                  'Nenhuma trilha publicada. Crie a primeira vivência offline.',
            )
          else
            for (final trail in trails) ...[
              _TrailCard(trail: trail),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _TrailCard extends StatelessWidget {
  const _TrailCard({required this.trail});

  final Trail trail;

  Color get _levelBackground => switch (trail.level) {
    TrailLevel.light => const Color(0xFFE4F5E9),
    TrailLevel.moderate => const Color(0xFFFFF2D6),
    TrailLevel.denseForest => const Color(0xFFFFE3DF),
  };

  Color get _levelForeground => switch (trail.level) {
    TrailLevel.light => const Color(0xFF2E7D45),
    TrailLevel.moderate => const Color(0xFF9A6400),
    TrailLevel.denseForest => AppVisualIdentity.cookTerracotta,
  };

  @override
  Widget build(BuildContext context) => OperationCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppVisualIdentity.softGreen,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.terrain_outlined,
            color: AppVisualIdentity.primaryGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trail.name,
                style: const TextStyle(
                  color: AppVisualIdentity.darkGreen,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _levelBackground,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      trail.level.label,
                      style: TextStyle(
                        color: _levelForeground,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _TrailMeta(
                    icon: Icons.schedule_outlined,
                    value: trail.duration,
                  ),
                  _TrailMeta(
                    icon: Icons.people_outline_rounded,
                    value: '${trail.maxPeople}',
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Text(
                'GPS: ${trail.gpsCoordinates}',
                style: const TextStyle(
                  color: AppVisualIdentity.mutedText,
                  fontFamily: 'monospace',
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TrailMeta extends StatelessWidget {
  const _TrailMeta({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: AppVisualIdentity.mutedText),
      const SizedBox(width: 3),
      Text(
        value,
        style: const TextStyle(
          color: AppVisualIdentity.mutedText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
