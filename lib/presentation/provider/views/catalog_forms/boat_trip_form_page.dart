import 'package:flutter/material.dart';

import '../../../../domain/provider_catalog/catalog_validation.dart';
import '../../../../domain/provider_catalog/models.dart';
import '../../state/provider_catalog_controller.dart';
import '../../state/provider_catalog_scope.dart';
import 'provider_form_widgets.dart';

class BoatTripFormPage extends StatefulWidget {
  const BoatTripFormPage({super.key, this.controller});

  final ProviderCatalogController? controller;

  @override
  State<BoatTripFormPage> createState() => _BoatTripFormPageState();
}

class _BoatTripFormPageState extends State<BoatTripFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _boatController = TextEditingController(text: 'Voadeira Rio Negro II');
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController();
  var _departure = '08:30';
  var _capacity = 8;
  var _isSubmitting = false;

  @override
  void dispose() {
    _boatController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final departureError = CatalogValidation.time(_departure, 'o horário');
    if (departureError != null) {
      showCatalogMessage(context, departureError);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final price = double.parse(_priceController.text.replaceAll(',', '.'));
      await (widget.controller ?? ProviderCatalogScope.of(context))
          .createBoatTrip(
            BoatTrip(
              id: createCatalogId('boat-trip'),
              boatName: _boatController.text.trim(),
              origin: _originController.text.trim(),
              destination: _destinationController.text.trim(),
              departureTime: _departure,
              maxCapacity: _capacity,
              currentBooked: 0,
              pricePerSeat: price,
            ),
          );
      if (!mounted) {
        return;
      }
      showCatalogMessage(context, 'Saída salva offline.');
      Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        showCatalogMessage(
          context,
          'Não foi possível salvar a saída. Tente novamente.',
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
    title: 'Nova Saída de Barco',
    submitLabel: 'CONFIRMAR SAÍDA (SALVAR OFFLINE)',
    onSubmit: _isSubmitting ? null : _submit,
    isSubmitting: _isSubmitting,
    body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CatalogTextField(
            controller: _boatController,
            label: 'Embarcação',
            icon: Icons.directions_boat_filled_outlined,
            validator: (value) =>
                CatalogValidation.requiredText(value, 'a embarcação'),
          ),
          const SizedBox(height: 20),
          const CatalogFieldLabel(text: 'Trecho Fluvial'),
          CatalogTextField(
            controller: _originController,
            label: 'Origem',
            icon: Icons.trip_origin_rounded,
            hint: 'Origem (ex: Manaus)',
            validator: (value) =>
                CatalogValidation.requiredText(value, 'a origem'),
          ),
          const SizedBox(height: 12),
          CatalogTextField(
            controller: _destinationController,
            label: 'Destino',
            icon: Icons.location_on_outlined,
            hint: 'Destino (ex: Tumbira)',
            validator: (value) =>
                CatalogValidation.requiredText(value, 'o destino'),
          ),
          const SizedBox(height: 20),
          CatalogFieldLabel(text: 'Horário de Partida'),
          Row(
            children: [
              _TimeButton(
                icon: Icons.remove_rounded,
                label: 'Adiantar partida em 30 minutos',
                onPressed: () => setState(
                  () => _departure = CatalogValidation.adjustTime(
                    _departure,
                    -30,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFDFE7E2)),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _departure,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _TimeButton(
                icon: Icons.add_rounded,
                label: 'Atrasar partida em 30 minutos',
                onPressed: () => setState(
                  () =>
                      _departure = CatalogValidation.adjustTime(_departure, 30),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CatalogStepper(
            label: 'Lotação Máxima (máx. 12)',
            value: _capacity,
            suffix: 'pessoas',
            onDecrease: _capacity == 1
                ? null
                : () => setState(() => _capacity--),
            onIncrease: _capacity == 12
                ? null
                : () => setState(() => _capacity++),
          ),
          const SizedBox(height: 20),
          CatalogTextField(
            controller: _priceController,
            label: 'Valor por Assento (R\$)',
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

class _TimeButton extends StatelessWidget {
  const _TimeButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    width: 52,
    child: IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: Color(0xFFDFE7E2)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}
