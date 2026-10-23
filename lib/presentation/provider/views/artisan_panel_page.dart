import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../core/theme/app_visual_identity.dart';
import '../../../domain/provider_catalog/models.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';
import '../state/provider_catalog_controller.dart';
import '../state/provider_catalog_scope.dart';
import 'boatman_panel_page.dart'
    show CatalogErrorState, EmptyCatalogState, UnavailableCatalogState;
import 'catalog_forms/craft_form_page.dart';

class ArtisanPanelPage extends StatelessWidget {
  const ArtisanPanelPage({super.key, this.controller});

  final ProviderCatalogController? controller;

  @override
  Widget build(BuildContext context) {
    final activeController =
        controller ?? ProviderCatalogScope.maybeOf(context);
    if (activeController == null) {
      return const ProviderPageScaffold(
        title: 'Painel da Artesã',
        body: UnavailableCatalogState(),
      );
    }
    return ListenableBuilder(
      listenable: activeController,
      builder: (context, _) => _ArtisanPanelBody(controller: activeController),
    );
  }
}

class _ArtisanPanelBody extends StatelessWidget {
  const _ArtisanPanelBody({required this.controller});

  final ProviderCatalogController controller;

  @override
  Widget build(BuildContext context) {
    final state = controller.crafts;
    if (state.status == ProviderCatalogStatus.loading) {
      return const ProviderPageScaffold(
        title: 'Painel da Artesã',
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.status == ProviderCatalogStatus.failure) {
      return ProviderPageScaffold(
        title: 'Painel da Artesã',
        body: CatalogErrorState(onRetry: controller.reload),
      );
    }
    final crafts = state.items;
    final totalStock = crafts.fold<int>(
      0,
      (total, craft) => total + craft.quantity,
    );
    return ProviderPageScaffold(
      title: 'Painel da Artesã',
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        children: [
          PanelHeaderCard(
            color: AppVisualIdentity.artisanGold,
            darkColor: AppVisualIdentity.artisanGoldDark,
            icon: Icons.diamond_outlined,
            name: 'Dona Zete',
            subtitle: 'Ateliê Ribeirinho',
            detail: Row(
              children: [
                Expanded(
                  child: MetricTile(
                    icon: Icons.inventory_2_outlined,
                    label: 'Em estoque',
                    value: '$totalStock Peças',
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: MetricTile(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Renda',
                    value: '100% no Território',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          DashboardPrimaryButton(
            key: const Key('artisan-add-craft'),
            label: 'CADASTRAR PEÇA DE ARTESANATO',
            icon: Icons.add_rounded,
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute(
                builder: (_) => CraftFormPage(controller: controller),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Vitrine Comunitária',
            style: TextStyle(
              color: AppVisualIdentity.darkGreen,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (crafts.isEmpty)
            const EmptyCatalogState(
              message:
                  'Nenhuma peça cadastrada. Monte a vitrine da comunidade.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: crafts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth >= 312 ? 2 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: constraints.maxWidth >= 312 ? 0.52 : 0.95,
                ),
                itemBuilder: (context, index) =>
                    _CraftCard(craft: crafts[index], controller: controller),
              ),
            ),
        ],
      ),
    );
  }
}

class _CraftCard extends StatelessWidget {
  const _CraftCard({required this.craft, required this.controller});

  final Craft craft;
  final ProviderCatalogController controller;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppVisualIdentity.subtleBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CraftImage(controller: controller, craft: craft),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  craft.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppVisualIdentity.darkGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  craft.rawMaterial.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppVisualIdentity.mutedText,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                Text(
                  'R\$ ${craft.price.toStringAsFixed(craft.price % 1 == 0 ? 0 : 2)}',
                  style: const TextStyle(
                    color: AppVisualIdentity.primaryGreen,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                QuantityStepper(
                  label: 'estoque de ${craft.name}',
                  value: craft.quantity,
                  valueKey: Key('craft-${craft.id}-quantity'),
                  decreaseKey: Key('craft-${craft.id}-decrease'),
                  increaseKey: Key('craft-${craft.id}-increase'),
                  onDecrease: craft.quantity == 0 || controller.isWriting
                      ? null
                      : () => controller.updateCraftQuantity(
                          craft.id,
                          craft.quantity - 1,
                        ),
                  onIncrease: controller.isWriting
                      ? null
                      : () => controller.updateCraftQuantity(
                          craft.id,
                          craft.quantity + 1,
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _CraftImage extends StatefulWidget {
  const _CraftImage({required this.controller, required this.craft});

  final ProviderCatalogController controller;
  final Craft craft;

  @override
  State<_CraftImage> createState() => _CraftImageState();
}

class _CraftImageState extends State<_CraftImage> {
  late Future<Uint8List?> _image;

  @override
  void initState() {
    super.initState();
    _image = widget.controller.craftImage(widget.craft.photoPath);
  }

  @override
  void didUpdateWidget(covariant _CraftImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.craft.photoPath != widget.craft.photoPath) {
      _image = widget.controller.craftImage(widget.craft.photoPath);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 108,
    width: double.infinity,
    child: FutureBuilder<Uint8List?>(
      future: _image,
      builder: (context, snapshot) {
        final image = snapshot.data;
        if (image != null) {
          return Image.memory(
            image,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _placeholder(),
          );
        }
        return _placeholder();
      },
    ),
  );

  Widget _placeholder() => Container(
    color: AppVisualIdentity.softGreen,
    alignment: Alignment.center,
    child: const Icon(
      Icons.photo_camera_back_outlined,
      color: AppVisualIdentity.primaryGreen,
      size: 36,
    ),
  );
}
