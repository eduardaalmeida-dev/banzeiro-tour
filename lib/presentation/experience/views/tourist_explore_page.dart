import 'package:flutter/material.dart';

import '../../../core/theme/app_visual_identity.dart';
import '../../dashboard/data/demo_dashboard_data.dart';
import '../../dashboard/models/dashboard_models.dart';
import '../../dashboard/widgets/dashboard_widgets.dart';

class TouristExplorePage extends StatefulWidget {
  const TouristExplorePage({super.key});

  @override
  State<TouristExplorePage> createState() => _TouristExplorePageState();
}

class _TouristExplorePageState extends State<TouristExplorePage> {
  ExperienceCategory _activeCategory = ExperienceCategory.all;
  String _query = '';

  Iterable<Experience> get _experiences =>
      DemoDashboardData.experiences.where((experience) {
        final categoryMatches =
            _activeCategory == ExperienceCategory.all ||
            experience.category == _activeCategory;
        final query = _query.toLowerCase();
        final searchMatches =
            query.isEmpty ||
            experience.title.toLowerCase().contains(query) ||
            experience.providerName.toLowerCase().contains(query);

        return categoryMatches && searchMatches;
      });

  void _selectNavigation(TouristNavigationItem item) {
    if (item != TouristNavigationItem.explore) {
      showFeatureUnavailable(context, item.label);
    }
  }

  @override
  Widget build(BuildContext context) {
    final experiences = _experiences.toList();

    return Scaffold(
      backgroundColor: AppVisualIdentity.pageBackground,
      bottomNavigationBar: TouristBottomNavigation(
        onItemSelected: _selectNavigation,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _ExploreHeader(),
            SizedBox(
              height: 62,
              child: ListView.separated(
                key: const Key('explore-category-list'),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 9,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: ExperienceCategory.values.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = ExperienceCategory.values[index];
                  final selected = category == _activeCategory;

                  return Semantics(
                    button: true,
                    selected: selected,
                    label: category.label,
                    child: SizedBox(
                      height: 44,
                      child: ChoiceChip(
                        key: Key('category-${category.name}'),
                        label: Text(category.label),
                        selected: selected,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() => _activeCategory = category);
                        },
                        selectedColor: AppVisualIdentity.primaryGreen,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: selected
                              ? AppVisualIdentity.primaryGreen
                              : AppVisualIdentity.subtleBorder,
                        ),
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : AppVisualIdentity.darkGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ResponsiveContent(
                child: experiences.isEmpty
                    ? const _EmptyExperienceState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: experiences.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) =>
                            _ExperienceCard(experience: experiences[index]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExploreHeader extends StatefulWidget {
  const _ExploreHeader();

  @override
  State<_ExploreHeader> createState() => _ExploreHeaderState();
}

class _ExploreHeaderState extends State<_ExploreHeader> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_TouristExplorePageState>()!;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 15),
      child: ResponsiveContent(
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppVisualIdentity.primaryGreen,
                ),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'RDS Rio Negro, AM',
                    style: TextStyle(
                      color: AppVisualIdentity.darkGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.waves_outlined,
                  size: 16,
                  color: AppVisualIdentity.primaryGreen,
                ),
                const SizedBox(width: 4),
                const Text(
                  'Online',
                  style: TextStyle(
                    color: AppVisualIdentity.mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            SizedBox(
              height: 48,
              child: TextField(
                key: const Key('explore-search'),
                controller: _controller,
                onChanged: (value) =>
                    state.setState(() => state._query = value),
                decoration: InputDecoration(
                  hintText: 'Buscar experiências...',
                  hintStyle: const TextStyle(
                    color: AppVisualIdentity.mutedText,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppVisualIdentity.mutedText,
                  ),
                  filled: true,
                  fillColor: AppVisualIdentity.fieldBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppVisualIdentity.primaryGreen,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience});

  final Experience experience;

  @override
  Widget build(BuildContext context) => Container(
    key: Key('experience-${experience.id}'),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppVisualIdentity.subtleBorder),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A103B27),
          blurRadius: 14,
          offset: Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            DashboardNetworkImage(
              imageUrl: experience.imageUrl,
              semanticLabel: 'Imagem de ${experience.title}',
              height: 176,
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _ImageBadge(
                icon: Icons.star_rounded,
                label: experience.rating.toStringAsFixed(1),
                foreground: AppVisualIdentity.darkGreen,
                background: Colors.white.withValues(alpha: 0.94),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: _ImageBadge(
                label: experience.community,
                foreground: Colors.white,
                background: AppVisualIdentity.darkGreen.withValues(alpha: 0.86),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                experience.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppVisualIdentity.darkGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                experience.providerName,
                style: const TextStyle(
                  color: AppVisualIdentity.mutedText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final price = Wrap(
                    spacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        'R\$ ${experience.price}',
                        style: const TextStyle(
                          color: AppVisualIdentity.primaryGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          '/ ${experience.priceUnit}',
                          style: const TextStyle(
                            color: AppVisualIdentity.mutedText,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  );
                  final reviews = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF2B126),
                        size: 15,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${experience.reviews} avaliações',
                        style: const TextStyle(
                          color: AppVisualIdentity.mutedText,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );

                  if (constraints.maxWidth < 440) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [price, const SizedBox(height: 7), reviews],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [price, reviews],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({
    this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });

  final IconData? icon;
  final String label;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: const Color(0xFFF2B126)),
          const SizedBox(width: 3),
        ],
        Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _EmptyExperienceState extends StatelessWidget {
  const _EmptyExperienceState();

  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Nenhuma experiência encontrada',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppVisualIdentity.mutedText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
