import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domain/provider_catalog/catalog_validation.dart';
import '../../../../domain/provider_catalog/models.dart';
import '../../state/provider_catalog_controller.dart';
import '../../state/provider_catalog_scope.dart';
import 'provider_form_widgets.dart';

abstract interface class CraftPhotoPicker {
  Future<Uint8List?> pick(ImageSource source);
  Future<Uint8List?> recoverLostImage();
}

class DeviceCraftPhotoPicker implements CraftPhotoPicker {
  DeviceCraftPhotoPicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<Uint8List?> pick(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      maxWidth: 1400,
      imageQuality: 82,
    );
    return image?.readAsBytes();
  }

  @override
  Future<Uint8List?> recoverLostImage() async {
    final response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      return response.file!.readAsBytes();
    }
    throw response.exception ??
        StateError('Não foi possível recuperar a imagem.');
  }
}

class CraftFormPage extends StatefulWidget {
  CraftFormPage({super.key, this.controller, CraftPhotoPicker? photoPicker})
    : photoPicker = photoPicker ?? DeviceCraftPhotoPicker();

  final ProviderCatalogController? controller;
  final CraftPhotoPicker photoPicker;

  @override
  State<CraftFormPage> createState() => _CraftFormPageState();
}

class _CraftFormPageState extends State<CraftFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  CraftMaterial? _material;
  Uint8List? _photoBytes;
  var _quantity = 1;
  var _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _recoverLostImage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _recoverLostImage() async {
    try {
      final bytes = await widget.photoPicker.recoverLostImage();
      if (mounted && bytes != null) {
        setState(() => _photoBytes = bytes);
      }
    } catch (_) {
      if (mounted) {
        showCatalogMessage(
          context,
          'Não foi possível recuperar a fotografia anterior.',
        );
      }
    }
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final bytes = await widget.photoPicker.pick(source);
      if (mounted && bytes != null) {
        setState(() => _photoBytes = bytes);
      }
    } catch (_) {
      if (mounted) {
        showCatalogMessage(
          context,
          source == ImageSource.camera
              ? 'A câmera não está disponível neste dispositivo. Escolha uma imagem.'
              : 'Não foi possível selecionar a imagem.',
        );
      }
    }
  }

  Future<void> _submit() async {
    final materialError = _material == null
        ? 'Selecione a matéria-prima.'
        : null;
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (materialError != null) {
      showCatalogMessage(context, materialError);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      final id = createCatalogId('craft');
      await (widget.controller ?? ProviderCatalogScope.of(context)).createCraft(
        Craft(
          id: id,
          photoPath: CraftImagePath.placeholder,
          name: _nameController.text.trim(),
          rawMaterial: _material!,
          quantity: _quantity,
          price: double.parse(_priceController.text.replaceAll(',', '.')),
        ),
        imageBytes: _photoBytes,
      );
      if (!mounted) {
        return;
      }
      showCatalogMessage(context, 'Peça adicionada à vitrine comunitária.');
      Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        showCatalogMessage(
          context,
          'Não foi possível salvar a peça. Tente novamente.',
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
    title: 'Nova Peça de Artesanato',
    submitLabel: 'COLOCAR NA VITRINE COMUNITÁRIA',
    onSubmit: _isSubmitting ? null : _submit,
    isSubmitting: _isSubmitting,
    body: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CatalogFieldLabel(text: 'Foto da Peça'),
          DashedActionCard(
            label: _photoBytes == null
                ? 'Fotografar Peça com a Câmera'
                : 'Foto capturada — toque para trocar',
            icon: Icons.camera_alt_outlined,
            onPressed: () => _pickPhoto(ImageSource.camera),
            child: _photoBytes == null
                ? null
                : SizedBox(
                    height: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(_photoBytes!, fit: BoxFit.cover),
                    ),
                  ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _pickPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Escolher da galeria'),
            ),
          ),
          const SizedBox(height: 8),
          CatalogTextField(
            controller: _nameController,
            label: 'Nome da Peça',
            icon: Icons.diamond_outlined,
            hint: 'ex: Colar de Jarina',
            validator: (value) =>
                CatalogValidation.requiredText(value, 'o nome da peça'),
          ),
          const SizedBox(height: 20),
          CatalogChoicePills<CraftMaterial>(
            label: 'Matéria-prima',
            value: _material,
            onChanged: (value) => setState(() => _material = value),
            choices: CraftMaterial.values
                .map(
                  (material) =>
                      CatalogChoice(value: material, label: material.label),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 20),
          CatalogStepper(
            label: 'Quantidade',
            value: _quantity,
            suffix: 'peças',
            onDecrease: _quantity == 1
                ? null
                : () => setState(() => _quantity--),
            onIncrease: _quantity == 99
                ? null
                : () => setState(() => _quantity++),
          ),
          const SizedBox(height: 20),
          CatalogTextField(
            controller: _priceController,
            label: 'Preço (R\$)',
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
