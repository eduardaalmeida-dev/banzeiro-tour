import 'package:flutter/material.dart';

import '../../../core/theme/app_visual_identity.dart';
import '../models/dashboard_models.dart';

void showFeatureUnavailable(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text('$feature estará disponível em breve.')),
    );
}

class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 620),
      child: child,
    ),
  );
}

class ProviderPageScaffold extends StatelessWidget {
  const ProviderPageScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppVisualIdentity.pageBackground,
    body: SafeArea(
      child: Column(
        children: [
          DashboardAppBar(title: title),
          Expanded(child: ResponsiveContent(child: body)),
        ],
      ),
    ),
  );
}

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(bottom: BorderSide(color: AppVisualIdentity.subtleBorder)),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: AppVisualIdentity.darkGreen,
        fontSize: 17,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class PanelHeaderCard extends StatelessWidget {
  const PanelHeaderCard({
    super.key,
    required this.color,
    required this.darkColor,
    required this.icon,
    required this.name,
    required this.subtitle,
    required this.detail,
  });

  final Color color;
  final Color darkColor;
  final IconData icon;
  final String name;
  final String subtitle;
  final Widget detail;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color, darkColor],
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.22),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, semanticLabel: subtitle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        detail,
      ],
    ),
  );
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.16),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.76)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.76),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class DashboardPrimaryButton extends StatelessWidget {
  const DashboardPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 54,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: AppVisualIdentity.primaryGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

class DashboardOutlinedButton extends StatelessWidget {
  const DashboardOutlinedButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppVisualIdentity.darkGreen,
        side: const BorderSide(
          color: AppVisualIdentity.primaryGreen,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

class OperationCard extends StatelessWidget {
  const OperationCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppVisualIdentity.subtleBorder),
    ),
    child: child,
  );
}

class CapacityProgress extends StatelessWidget {
  const CapacityProgress({
    super.key,
    required this.current,
    required this.capacity,
    required this.label,
    this.useWords = false,
  });

  final int current;
  final int capacity;
  final String label;
  final bool useWords;

  @override
  Widget build(BuildContext context) {
    final progress = DashboardMath.progress(current, capacity);
    final percentage = (progress * 100).round();
    final color = progress >= 0.8
        ? AppVisualIdentity.capacityHigh
        : progress >= 0.5
        ? AppVisualIdentity.capacityMedium
        : AppVisualIdentity.primaryGreen;
    final amountLabel = useWords
        ? '$current de $capacity $label'
        : '$current/$capacity $label';

    return Semantics(
      label: '$amountLabel, $percentage% ocupado',
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.people_outline_rounded,
                size: 15,
                color: AppVisualIdentity.mutedText,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  amountLabel,
                  style: const TextStyle(
                    color: AppVisualIdentity.mutedText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$percentage% ocupado',
                style: const TextStyle(
                  color: AppVisualIdentity.mutedText,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress,
              color: color,
              backgroundColor: AppVisualIdentity.fieldBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.label,
    required this.onDecrease,
    required this.onIncrease,
    this.decreaseKey,
    this.increaseKey,
    this.valueKey,
  });

  final int value;
  final String label;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;
  final Key? decreaseKey;
  final Key? increaseKey;
  final Key? valueKey;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _StepButton(
        key: decreaseKey,
        icon: Icons.remove_rounded,
        semanticLabel: 'Diminuir $label',
        onPressed: onDecrease,
      ),
      SizedBox(
        width: 38,
        child: Text(
          '$value',
          key: valueKey,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppVisualIdentity.darkGreen,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      _StepButton(
        key: increaseKey,
        icon: Icons.add_rounded,
        semanticLabel: 'Aumentar $label',
        onPressed: onIncrease,
      ),
    ],
  );
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    super.key,
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: semanticLabel,
    child: SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        tooltip: semanticLabel,
        color: AppVisualIdentity.darkGreen,
        style: IconButton.styleFrom(
          backgroundColor: AppVisualIdentity.fieldBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
  );
}

class DashboardNetworkImage extends StatelessWidget {
  const DashboardNetworkImage({
    super.key,
    required this.imageUrl,
    required this.semanticLabel,
    required this.height,
  });

  final String imageUrl;
  final String semanticLabel;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
      semanticLabel: semanticLabel,
      errorBuilder: (_, _, _) => Semantics(
        label: semanticLabel,
        image: true,
        child: Container(
          color: AppVisualIdentity.softGreen,
          alignment: Alignment.center,
          child: const Icon(
            Icons.landscape_outlined,
            color: AppVisualIdentity.primaryGreen,
            size: 36,
          ),
        ),
      ),
    ),
  );
}

enum TouristNavigationItem { explore, passport, voucher, profile }

extension TouristNavigationItemDetails on TouristNavigationItem {
  String get label => switch (this) {
    TouristNavigationItem.explore => 'Explorar',
    TouristNavigationItem.passport => 'Passaporte',
    TouristNavigationItem.voucher => 'Meu Voucher',
    TouristNavigationItem.profile => 'Perfil',
  };

  IconData get icon => switch (this) {
    TouristNavigationItem.explore => Icons.explore_outlined,
    TouristNavigationItem.passport => Icons.menu_book_outlined,
    TouristNavigationItem.voucher => Icons.confirmation_num_outlined,
    TouristNavigationItem.profile => Icons.person_outline_rounded,
  };
}

class TouristBottomNavigation extends StatelessWidget {
  const TouristBottomNavigation({
    super.key,
    this.activeItem = TouristNavigationItem.explore,
    required this.onItemSelected,
  });

  final TouristNavigationItem activeItem;
  final ValueChanged<TouristNavigationItem> onItemSelected;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppVisualIdentity.subtleBorder)),
      ),
      child: Row(
        children: TouristNavigationItem.values.map((item) {
          final active = item == activeItem;
          final color = active
              ? AppVisualIdentity.primaryGreen
              : AppVisualIdentity.mutedText;

          return Expanded(
            child: Semantics(
              button: true,
              selected: active,
              label: item.label,
              child: InkWell(
                key: Key('tourist-nav-${item.name}'),
                onTap: () => onItemSelected(item),
                child: SizedBox(
                  height: 64,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: active
                              ? AppVisualIdentity.softGreen
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, color: color, size: 22),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: active
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}
