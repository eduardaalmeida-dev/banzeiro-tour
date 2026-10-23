import 'package:flutter/material.dart';

import '../../../../domain/provider_catalog/catalog_validation.dart';
import '../../../../domain/provider_catalog/models.dart';
import '../../state/provider_catalog_controller.dart';
import '../../state/provider_catalog_scope.dart';
import 'provider_form_widgets.dart';

class MealFormPage extends StatefulWidget {
  const MealFormPage({super.key, this.controller});

  final ProviderCatalogController? controller;

  @override
  State<MealFormPage> createState() => _MealFormPageState();
}

class _MealFormPageState extends State<MealFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _mealType = MealType.forestLunch;
  var _start = const TimeOfDay(hour: 11, minute: 30);
  var _end = const TimeOfDay(hour: 13, minute: 30);
  var _maxPortions = 20;
  final _priceController = TextEditingController();
  var _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String _format(TimeOfDay value) =>
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  Future<void> _selectTime(bool isStart) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );
    if (selected != null && mounted) {
      setState(() {
        if (isStart) {
          _start = selected;
        } else {
          _end = selected;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final start = _format(_start);
    final end = _format(_end);
    final windowError = CatalogValidation.timeWindow(start, end);
    if (windowError != null) {
      showCatalogMessage(context, windowError);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await (widget.controller ?? ProviderCatalogScope.of(context)).createMeal(
        Meal(
          id: createCatalogId('meal'),
          mealType: _mealType,
          dishName: _nameController.text.trim(),
          timeWindow: '$start - $end',
          maxPortions: _maxPortions,
          reservedPortions: 0,
          price: double.parse(_priceController.text.replaceAll(',', '.')),
        ),
      );
      if (!mounted) {
        return;
      }
      showCatalogMessage(context, 'Cardápio comunitário salvo.');
      Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        showCatalogMessage(
          context,
          'Não foi possível salvar o cardápio. Tente novamente.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => ProviderFormScaffold(
    title: 'Nova Refeição',
    submitLabel: 'SALVAR CARDÁPIO COMUNITÁRIO',
    onSubmit: _isSubmitting ? null : _submit,
    isSubmitting: _isSubmitting,
    body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogChoicePills<MealType>(
            label: 'Tipo de Refeição',
            value: _mealType,
            expanded: true,
            onChanged: (value) => setState(() => _mealType = value),
            choices: MealType.values
                .map((type) => CatalogChoice(value: type, label: type.label))
                .toList(growable: false),
          ),
          const SizedBox(height: 20),
          CatalogTextField(
            controller: _nameController,
            label: 'Nome do Prato',
            icon: Icons.restaurant_outlined,
            hint: 'ex: Peixe Moqueado com Farinha',
            validator: (value) =>
                CatalogValidation.requiredText(value, 'o nome do prato'),
          ),
          const SizedBox(height: 20),
          const CatalogFieldLabel(text: 'Janela de Atendimento'),
          Row(
            children: [
              Expanded(
                child: _TimeSelector(
                  label: 'Início',
                  value: _format(_start),
                  onPressed: () => _selectTime(true),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_forward_rounded),
              ),
              Expanded(
                child: _TimeSelector(
                  label: 'Fim',
                  value: _format(_end),
                  onPressed: () => _selectTime(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CatalogStepper(
            label: 'Limite de Porções',
            value: _maxPortions,
            suffix: 'porções',
            onDecrease: _maxPortions == 1
                ? null
                : () => setState(() => _maxPortions--),
            onIncrease: _maxPortions == 100
                ? null
                : () => setState(() => _maxPortions++),
          ),
          const SizedBox(height: 20),
          CatalogTextField(
            controller: _priceController,
            label: 'Preço por Refeição (R\$)',
            icon: Icons.attach_money_rounded,
            hint: '0,00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: CatalogValidation.positivePrice,
          ),
        ],
      ),
    ),
  );
}

class _TimeSelector extends StatelessWidget {
  const _TimeSelector({
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      foregroundColor: const Color(0xFF103B27),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFDFE7E2)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 10)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}
