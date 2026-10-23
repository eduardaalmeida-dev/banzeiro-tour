import 'package:flutter/material.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/auth_session.dart';
import '../../../core/theme/app_visual_identity.dart';
import '../../home/views/role_landing_page.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key, this.apiService, this.session});

  final ApiService? apiService;
  final AuthSession? session;

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  static const _primaryGreen = AppVisualIdentity.primaryGreen;
  static const _darkGreen = AppVisualIdentity.darkGreen;
  static const _softGreen = AppVisualIdentity.softGreen;
  static const _pageBackground = AppVisualIdentity.pageBackground;
  static const _fieldBackground = AppVisualIdentity.fieldBackground;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _travelPreferencesController = TextEditingController();
  final _phoneController = TextEditingController();
  final _serviceDescriptionController = TextEditingController();
  final _professionalMetadataController = TextEditingController();
  final _apiFieldErrors = <String, List<String>>{};

  late final ApiService _apiService;
  late final AuthSession _session;
  UserProfileType? _profileType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    _session = widget.session ?? AuthSession();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _travelPreferencesController.dispose();
    _phoneController.dispose();
    _serviceDescriptionController.dispose();
    _professionalMetadataController.dispose();
    super.dispose();
  }

  void _clearApiError(String field) {
    if (_apiFieldErrors.remove(field) != null) {
      setState(() {});
    }
  }

  String? _requiredValidator(String? value, String field) {
    final apiError = _apiFieldErrors[field]?.first;

    if (apiError != null) {
      return apiError;
    }

    if (value == null || value.trim().isEmpty) {
      return 'Este campo é obrigatório.';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    final requiredError = _requiredValidator(value, 'email');

    if (requiredError != null || value == null) {
      return requiredError;
    }

    if (!value.contains('@')) {
      return 'Informe um e-mail válido.';
    }

    return null;
  }

  String? _passwordValidator(String? value) {
    final requiredError = _requiredValidator(value, 'password');

    if (requiredError != null || value == null) {
      return requiredError;
    }

    if (value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres.';
    }

    return null;
  }

  Future<void> _handleRegistration() async {
    if (_profileType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha um perfil para continuar.')),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _apiFieldErrors.clear();
    });

    final profileType = _profileType!;
    final result = await _apiService.register(
      RegistrationRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        profileType: profileType,
        travelPreferences: profileType == UserProfileType.tourist
            ? {'preferences': _travelPreferencesController.text.trim()}
            : null,
        phone: profileType.isProvider ? _phoneController.text.trim() : null,
        serviceDescription: profileType.isProvider
            ? _serviceDescriptionController.text.trim()
            : null,
        professionalMetadata: profileType.isProvider
            ? {'details': _professionalMetadataController.text.trim()}
            : null,
      ),
    );

    if (!mounted) {
      return;
    }

    if (result is RegistrationAuthenticated) {
      await _session.saveToken(result.token);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => RoleLandingPage(profileType: result.user.profileType),
        ),
        (_) => false,
      );
      return;
    }

    setState(() => _isLoading = false);

    if (result is RegistrationValidationFailure) {
      setState(() => _apiFieldErrors.addAll(result.fieldErrors));
      _formKey.currentState?.validate();
      return;
    }

    final message = result is RegistrationNetworkFailure
        ? 'Não foi possível conectar ao servidor. Tente novamente.'
        : 'Não foi possível concluir o cadastro. Tente novamente.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        color: Color(0xFF527060),
        fontWeight: FontWeight.w600,
      ),
      hintStyle: const TextStyle(color: Color(0xFF91A398)),
      prefixIcon: Icon(icon, color: _primaryGreen, size: 21),
      filled: true,
      fillColor: _fieldBackground,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: _primaryGreen, width: 1.5),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  IconData _profileIcon(UserProfileType profile) {
    return switch (profile) {
      UserProfileType.tourist => Icons.explore_outlined,
      UserProfileType.boatman => Icons.directions_boat_outlined,
      UserProfileType.guide => Icons.map_outlined,
      UserProfileType.artisan => Icons.palette_outlined,
      UserProfileType.cook => Icons.restaurant_outlined,
    };
  }

  String _profileDescription(UserProfileType profile) {
    return profile.isProvider
        ? 'Conte sobre seu serviço para iniciar a homologação.'
        : 'Personalize as experiências que deseja encontrar.';
  }

  @override
  Widget build(BuildContext context) {
    final isTourist = _profileType == UserProfileType.tourist;
    final isProvider = _profileType?.isProvider ?? false;

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: _primaryGreen,
                      tooltip: 'Voltar',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const Text(
                'Vamos criar\nsua conta?',
                style: TextStyle(
                  color: _darkGreen,
                  fontSize: 31,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Escolha seu perfil e prepare-se para viver a Amazônia.',
                style: TextStyle(
                  color: Color(0xFF6B8275),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Como você quer explorar?',
                style: TextStyle(
                  color: _darkGreen,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 10,
                children: UserProfileType.values.map((profile) {
                  final selected = _profileType == profile;

                  return ChoiceChip(
                    key: Key('profile-${profile.apiValue}'),
                    avatar: Icon(
                      _profileIcon(profile),
                      size: 18,
                      color: selected ? Colors.white : _primaryGreen,
                    ),
                    label: Text(profile.label),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: _primaryGreen,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: selected
                          ? _primaryGreen
                          : AppVisualIdentity.subtleBorder,
                    ),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : _darkGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 9,
                    ),
                    onSelected: (_) => setState(() {
                      _profileType = profile;
                    }),
                  );
                }).toList(),
              ),
              if (_profileType != null) ...[
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _softGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: _primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _profileIcon(_profileType!),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Perfil ${_profileType!.label}',
                              style: const TextStyle(
                                color: _darkGreen,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              _profileDescription(_profileType!),
                              style: const TextStyle(
                                color: Color(0xFF557266),
                                fontSize: 13,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 28),
              const Text(
                'Seus dados',
                style: TextStyle(
                  color: _darkGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Precisamos de algumas informações para começar.',
                style: TextStyle(color: Color(0xFF6B8275), fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D103B27),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key('registration-name'),
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _fieldDecoration(
                        label: 'Nome completo',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (value) => _requiredValidator(value, 'name'),
                      onChanged: (_) => _clearApiError('name'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const Key('registration-email'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _fieldDecoration(
                        label: 'E-mail',
                        icon: Icons.mail_outline_rounded,
                      ),
                      validator: _emailValidator,
                      onChanged: (_) => _clearApiError('email'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const Key('registration-password'),
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _fieldDecoration(
                        label: 'Senha',
                        hint: 'Pelo menos 8 caracteres',
                        icon: Icons.lock_outline_rounded,
                      ),
                      validator: _passwordValidator,
                      onChanged: (_) => _clearApiError('password'),
                    ),
                    if (isTourist) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('registration-travel-preferences'),
                        controller: _travelPreferencesController,
                        maxLines: 3,
                        decoration: _fieldDecoration(
                          label: 'Preferências de viagem',
                          hint: 'Ex.: trilhas, rios, culinária local',
                          icon: Icons.favorite_border_rounded,
                        ),
                        validator: (value) =>
                            _requiredValidator(value, 'travel_preferences'),
                        onChanged: (_) => _clearApiError('travel_preferences'),
                      ),
                    ],
                    if (isProvider) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('registration-phone'),
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _fieldDecoration(
                          label: 'Telefone',
                          icon: Icons.phone_outlined,
                        ),
                        validator: (value) =>
                            _requiredValidator(value, 'phone'),
                        onChanged: (_) => _clearApiError('phone'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('registration-service-description'),
                        controller: _serviceDescriptionController,
                        maxLines: 3,
                        decoration: _fieldDecoration(
                          label: 'Descrição do serviço',
                          hint: 'Conte o que você oferece',
                          icon: Icons.format_align_left_rounded,
                        ),
                        validator: (value) =>
                            _requiredValidator(value, 'service_description'),
                        onChanged: (_) => _clearApiError('service_description'),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        key: const Key('registration-professional-metadata'),
                        controller: _professionalMetadataController,
                        maxLines: 3,
                        decoration: _fieldDecoration(
                          label: 'Metadados profissionais',
                          hint: 'Experiência, certificações ou referências',
                          icon: Icons.workspace_premium_outlined,
                        ),
                        validator: (value) =>
                            _requiredValidator(value, 'professional_metadata'),
                        onChanged: (_) =>
                            _clearApiError('professional_metadata'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('registration-submit'),
                onPressed: _isLoading ? null : _handleRegistration,
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 2,
                  shadowColor: _primaryGreen.withValues(alpha: 0.35),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Criar minha conta'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ao continuar, você concorda em criar uma conta no Banzeiro Tour.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7A9184),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
