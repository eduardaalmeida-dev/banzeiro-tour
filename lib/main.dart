import 'package:flutter/material.dart';

import 'core/bootstrap/app_bootstrap.dart';
import 'core/theme/app_visual_identity.dart';
import 'presentation/auth/views/login_view.dart';
import 'presentation/provider/state/provider_catalog_controller.dart';
import 'presentation/provider/state/provider_catalog_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final catalogController = ProviderCatalogController(
    bootstrap: AppBootstrap.providerCatalogRepositories,
  );
  await catalogController.initialize();
  runApp(BanzeiroTourApp(catalogController: catalogController));
}

class BanzeiroTourApp extends StatelessWidget {
  const BanzeiroTourApp({super.key, required this.catalogController});

  final ProviderCatalogController catalogController;

  @override
  Widget build(BuildContext context) {
    return ProviderCatalogScope(
      controller: catalogController,
      child: MaterialApp(
        title: 'Banzeiro Tour',
        debugShowCheckedModeBanner: false,
        theme: AppVisualIdentity.theme,
        home: const LoginView(),
      ),
    );
  }
}
