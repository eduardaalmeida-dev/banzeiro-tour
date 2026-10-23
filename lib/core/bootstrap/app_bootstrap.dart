import '../../data/local/local_database.dart';
import '../../data/repositories/provider_catalog_repositories.dart';

abstract final class AppBootstrap {
  static Future<ProviderCatalogRepositories>
  providerCatalogRepositories() async {
    final database = await LocalDatabase.initialize();
    return ProviderCatalogRepositories.fromDatabase(database);
  }
}
