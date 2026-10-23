import 'package:flutter/material.dart';

import '../../../../core/theme/app_visual_identity.dart';

class ProviderFormScaffold extends StatelessWidget {
  const ProviderFormScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.submitLabel,
    required this.onSubmit,
    required this.isSubmitting,
  });

  final String title;
  final Widget body;
  final String submitLabel;
  final VoidCallback? onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppVisualIdentity.pageBackground,
    body: SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  key: const Key('catalog-form-back'),
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: 'Voltar',
                ),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppVisualIdentity.darkGreen,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
                  child: body,
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppVisualIdentity.subtleBorder),
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      key: const Key('catalog-form-submit'),
                      onPressed: onSubmit,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppVisualIdentity.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              submitLabel,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class CatalogFieldLabel extends StatelessWidget {
  const CatalogFieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppVisualIdentity.mutedText,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    ),
  );
}

class CatalogTextField extends StatelessWidget {
  const CatalogTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.validator,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CatalogFieldLabel(text: label),
      TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppVisualIdentity.mutedText),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppVisualIdentity.subtleBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppVisualIdentity.subtleBorder),
          ),
        ),
      ),
    ],
  );
}

class CatalogChoice<T> {
  const CatalogChoice({required this.value, required this.label});

  final T value;
  final String label;
}

class CatalogChoicePills<T> extends StatelessWidget {
  const CatalogChoicePills({
    super.key,
    required this.label,
    required this.choices,
    required this.value,
    required this.onChanged,
    this.expanded = false,
  });

  final String label;
  final List<CatalogChoice<T>> choices;
  final T? value;
  final ValueChanged<T> onChanged;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final children = choices
        .map(
          (choice) => _ChoiceButton(
            label: choice.label,
            selected: choice.value == value,
            onPressed: () => onChanged(choice.value),
          ),
        )
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CatalogFieldLabel(text: label),
        expanded
            ? Row(
                children: children
                    .map(
                      (child) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: child,
                        ),
                      ),
                    )
                    .toList(growable: false),
              )
            : Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    label: label,
    child: OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        backgroundColor: selected
            ? AppVisualIdentity.primaryGreen
            : Colors.white,
        foregroundColor: selected ? Colors.white : AppVisualIdentity.mutedText,
        side: BorderSide(
          color: selected
              ? AppVisualIdentity.primaryGreen
              : AppVisualIdentity.subtleBorder,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      ),
    ),
  );
}

class CatalogStepper extends StatelessWidget {
  const CatalogStepper({
    super.key,
    required this.label,
    required this.value,
    required this.suffix,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String label;
  final int value;
  final String suffix;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CatalogFieldLabel(text: label),
      Row(
        children: [
          _SquareIconButton(
            icon: Icons.remove_rounded,
            label: 'Diminuir $label',
            onPressed: onDecrease,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppVisualIdentity.subtleBorder),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text.rich(
                TextSpan(
                  text: '$value',
                  style: const TextStyle(
                    color: AppVisualIdentity.darkGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(
                      text: ' $suffix',
                      style: const TextStyle(
                        color: AppVisualIdentity.mutedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _SquareIconButton(
            icon: Icons.add_rounded,
            label: 'Aumentar $label',
            onPressed: onIncrease,
          ),
        ],
      ),
    ],
  );
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 50,
    height: 50,
    child: IconButton(
      onPressed: onPressed,
      tooltip: label,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppVisualIdentity.darkGreen,
        side: const BorderSide(color: AppVisualIdentity.subtleBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}

class DashedActionCard extends StatelessWidget {
  const DashedActionCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.child,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(68),
      foregroundColor: AppVisualIdentity.primaryGreen,
      side: const BorderSide(color: AppVisualIdentity.primaryGreen, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    child:
        child ??
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
  );
}

void showCatalogMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
