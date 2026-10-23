enum ExperienceCategory { all, boats, trails, crafts, food }

extension ExperienceCategoryLabel on ExperienceCategory {
  String get label => switch (this) {
    ExperienceCategory.all => 'Todos',
    ExperienceCategory.boats => 'Barcos Fluviais',
    ExperienceCategory.trails => 'Trilhas na Selva',
    ExperienceCategory.crafts => 'Artesanato',
    ExperienceCategory.food => 'Culinária',
  };
}

class Experience {
  const Experience({
    required this.id,
    required this.title,
    required this.category,
    required this.providerName,
    required this.price,
    required this.priceUnit,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.community,
  });

  final String id;
  final String title;
  final ExperienceCategory category;
  final String providerName;
  final int price;
  final String priceUnit;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String community;
}

abstract final class DashboardMath {
  static double progress(int current, int capacity) {
    if (capacity <= 0) {
      return 0;
    }

    return (current / capacity).clamp(0, 1).toDouble();
  }
}
