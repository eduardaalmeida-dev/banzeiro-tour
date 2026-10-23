import 'package:flutter/material.dart';

import '../../../../domain/provider_catalog/catalog_validation.dart';
import '../../../../domain/provider_catalog/models.dart';
import '../../state/provider_catalog_controller.dart';
import '../../state/provider_catalog_scope.dart';
import 'provider_form_widgets.dart';

class TrailFormPage extends StatefulWidget {
  const TrailFormPage({super.key, this.controller});

  final ProviderCatalogController? controller;

  @override
  State<TrailFormPage> createState() => _TrailFormPageState();
}

class _TrailFormPageState extends State<TrailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  var _level = TrailLevel.light;
  var _maxPeople = 8;
  var _gpsCoordinates = 'Não capturado';
  var _isCapturing = false;
  var _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _captureGps() async {
    setState(() => _isCapturing = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() {
        _gpsCoordinates = '-2.9998°, -59.9120°';
        _isCapturing = false;
      });
    }
  }

  Future<void> _submit() async {
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await (widget.controller ?? ProviderCatalogScope.of(context)).createTrail(
        Trail(
          id: createCatalogId('trail'),
          name: _nameController.text.trim(),
          level: _level,
          duration: _durationController.text.trim(),
          gpsCoordinates: _gpsCoordinates,
          maxPeople: _maxPeople,
        ),
      );
      if (!mounted) {
        return;
      }
      showCatalogMessage(context, 'Trilha publicada no catálogo.');
      Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        showCatalogMessage(
          context,
          'Não foi possível publicar a trilha. Tente novamente.',
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
    title: 'Nova Trilha',
    submitLabel: 'PUBLICAR TRILHA NO CATÁLOGO',
    onSubmit: _isSubmitting ? null : _submit,
    isSubmitting: _isSubmitting,
    body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogTextField(
            controller: _nameController,
            label: 'Nome da Trilha',
            icon: Icons.terrain_outlined,
            hint: 'ex: Trilha da Samaúma',
            validator: (value) =>
                CatalogValidation.requiredText(value, 'o nome da trilha'),
          ),
          const SizedBox(height: 20),
          CatalogChoicePills<TrailLevel>(
            label: 'Nível',
            value: _level,
            expanded: true,
            onChanged: (value) => setState(() => _level = value),
            choices: TrailLevel.values
                .map((level) => CatalogChoice(value: level, label: level.label))
                .toList(growable: false),
          ),
          const SizedBox(height: 20),
          CatalogTextField(
            controller: _durationController,
            label: 'Duração Estimada',
            icon: Icons.schedule_outlined,
            hint: 'ex: 3h',
            validator: (value) =>
                CatalogValidation.requiredText(value, 'a duração estimada'),
          ),
          const SizedBox(height: 20),
          const CatalogFieldLabel(text: 'Coordenadas GPS'),
          DashedActionCard(
            label: _isCapturing
                ? 'Capturando...'
                : _gpsCoordinates == 'Não capturado'
                ? 'Capturar Coordenadas GPS (Sem Internet)'
                : 'GPS: $_gpsCoordinates',
            icon: _isCapturing
                ? Icons.navigation_rounded
                : Icons.location_on_outlined,
            onPressed: _isCapturing ? null : _captureGps,
          ),
          const SizedBox(height: 20),
          CatalogStepper(
            label: 'Limite de Pessoas',
            value: _maxPeople,
            suffix: 'pessoas',
            onDecrease: _maxPeople == 1
                ? null
                : () => setState(() => _maxPeople--),
            onIncrease: _maxPeople == 30
                ? null
                : () => setState(() => _maxPeople++),
          ),
        ],
      ),
    ),
  );
}
