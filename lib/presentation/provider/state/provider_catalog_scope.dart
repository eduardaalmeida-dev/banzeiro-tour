import 'package:flutter/widgets.dart';

import 'provider_catalog_controller.dart';

class ProviderCatalogScope
    extends InheritedNotifier<ProviderCatalogController> {
  const ProviderCatalogScope({
    super.key,
    required ProviderCatalogController controller,
    required super.child,
  }) : super(notifier: controller);

  static ProviderCatalogController of(BuildContext context) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw FlutterError(
        'ProviderCatalogScope não foi encontrado na árvore de widgets.',
      );
    }
    return controller;
  }

  static ProviderCatalogController? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ProviderCatalogScope>()
      ?.notifier;
}
