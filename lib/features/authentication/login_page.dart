import 'package:balade/core/form_validator.dart';
import 'package:balade/features/admin/design/management_theme.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/authentication_service.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/features/authentication/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The only login screen: email, then the 6-digit code sent by email. The « Nouveau compte » form
/// only shows when the API does not know the email.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.email, this.redirection});

  /// Prefills the email, e.g. the contact email of a reservation.
  final String? email;

  /// Where to go once connected; without it, the landing depends on the role (see [landingAfterLogin]).
  final String? redirection;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

enum _Step { email, newAccount, code }

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  _Step _step = _Step.email;
  bool _isLoading = false;
  String? _error;

  /// When the code last sent stops working: the API gives it 5 minutes.
  DateTime? _codeExpiresAt;

  String get _email => _emailController.text.trim();

  @override
  void initState() {
    super.initState();
    if (widget.email != null) _emailController.text = widget.email!;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await action();
    } finally {
      _update(() => _isLoading = false);
    }
  }

  /// Updates the screen after a request, unless the user has left it meanwhile.
  void _update(VoidCallback change) {
    if (mounted) setState(change);
  }

  /// Sends the code straight away to a known email, asks for the new account otherwise.
  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;
    await _run(() async {
      try {
        final exists = await AuthenticationService.instance.checkEmailExists(_email);
        if (!mounted) return;
        if (!exists) {
          setState(() => _step = _Step.newAccount);
          return;
        }
        await _sendCode();
      } catch (_) {
        _update(() => _error = 'Impossible d\'envoyer le code. Vérifiez l\'email et réessayez.');
      }
    });
  }

  Future<void> _submitNewAccount() async {
    if (!_formKey.currentState!.validate()) return;
    await _run(() async {
      try {
        await _sendCode();
      } catch (_) {
        _update(() => _error = 'Impossible de créer le compte. Vérifiez les informations et réessayez.');
      }
    });
  }

  Future<void> _resendCode() => _run(() async {
    try {
      await _sendCode();
      if (mounted) _codeController.clear();
    } catch (_) {
      _update(() => _error = 'Impossible de renvoyer le code. Réessayez dans un instant.');
    }
  });

  Future<void> _sendCode() async {
    String? optional(TextEditingController controller) => controller.text.trim().isEmpty ? null : controller.text.trim();
    final isNew = _step == _Step.newAccount;
    await AuthenticationService.instance.authenticate(
      _email,
      firstName: isNew ? optional(_firstNameController) : null,
      lastName: isNew ? optional(_lastNameController) : null,
      phone: isNew ? optional(_phoneController) : null,
    );
    _update(() {
      _step = _Step.code;
      _codeExpiresAt = DateTime.now().add(const Duration(minutes: 5));
    });
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;
    await _run(() async {
      try {
        final result = await AuthenticationService.instance.verifyAuthentication(_email, _codeController.text.trim());
        if (result.user == null || result.token == null) throw Exception('Réponse invalide du serveur');
        final user = AuthedUser(user: result.user!, token: result.token!);
        await ref.read(authenticationProvider.notifier).login(user);
        if (mounted) context.go(landingAfterLogin(user.user, redirection: widget.redirection));
      } on PlatformException catch (e) {
        final expired = '${e.details}'.contains('expired');
        _update(
          () => _error = expired ? 'Ce code a expiré. Demandez un nouveau code avec « Renvoyer le code ».' : 'Ce code est incorrect. Vérifiez le code reçu par email, ou demandez-en un nouveau.',
        );
      } catch (_) {
        _update(() => _error = 'La connexion a échoué. Réessayez dans un instant.');
      }
    });
  }

  void _changeEmail() => setState(() {
    _step = _Step.email;
    _error = null;
    _codeExpiresAt = null;
    _codeController.clear();
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: managementTheme(Theme.of(context)),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: ManagementColors.background,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  decoration: BoxDecoration(
                    color: ManagementColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ManagementColors.border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(step: _step),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_error != null) ...[_ErrorMessage(_error!), const SizedBox(height: 16)],
                              ...switch (_step) {
                                _Step.email => _emailStep(),
                                _Step.newAccount => _newAccountStep(context),
                                _Step.code => _codeStep(context),
                              },
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _emailStep() => [
    TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.email],
      validator: (value) => (value ?? '').trim().isEmpty ? 'Saisissez votre adresse email' : FormValidator.emailValidator(value!.trim()),
      onFieldSubmitted: (_) => _submitEmail(),
      decoration: const InputDecoration(labelText: 'Adresse email', prefixIcon: Icon(Icons.email_outlined)),
    ),
    const SizedBox(height: 20),
    _PrimaryButton(label: 'Recevoir le code', icon: Icons.send_outlined, isLoading: _isLoading, onPressed: _submitEmail),
  ];

  List<Widget> _newAccountStep(BuildContext context) => [
    Text('Nouveau compte', style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: 4),
    Text('Aucun compte n\'existe pour $_email. Présentez-vous pour le créer.', style: Theme.of(context).textTheme.bodySmall),
    const SizedBox(height: 16),
    TextFormField(
      controller: _firstNameController,
      textCapitalization: TextCapitalization.words,
      validator: (value) => (value ?? '').trim().isEmpty ? 'Le prénom est requis' : null,
      decoration: const InputDecoration(labelText: 'Prénom', prefixIcon: Icon(Icons.person_outline)),
    ),
    const SizedBox(height: 12),
    TextFormField(
      controller: _lastNameController,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Nom (facultatif)'),
    ),
    const SizedBox(height: 12),
    TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(labelText: 'Téléphone (facultatif)'),
    ),
    const SizedBox(height: 20),
    _PrimaryButton(label: 'Créer le compte et recevoir le code', icon: Icons.send_outlined, isLoading: _isLoading, onPressed: _submitNewAccount),
    const SizedBox(height: 8),
    TextButton(onPressed: _isLoading ? null : _changeEmail, child: const Text('Changer d\'email')),
  ];

  List<Widget> _codeStep(BuildContext context) {
    final theme = Theme.of(context);
    final expiresAt = _codeExpiresAt;
    return [
      Text('Un code à 6 chiffres a été envoyé à $_email.', style: theme.textTheme.bodyMedium),
      if (expiresAt != null) ...[const SizedBox(height: 4), Text('Le code expire à ${TimeOfDay.fromDateTime(expiresAt).format(context)}.', style: theme.textTheme.bodySmall)],
      const SizedBox(height: 16),
      TextFormField(
        controller: _codeController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.oneTimeCode],
        maxLength: 6,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) => (value ?? '').trim().length != 6 ? 'Le code contient 6 chiffres' : null,
        onFieldSubmitted: (_) => _verifyCode(),
        decoration: const InputDecoration(labelText: 'Code à 6 chiffres', prefixIcon: Icon(Icons.lock_outline), counterText: ''),
      ),
      const SizedBox(height: 20),
      _PrimaryButton(label: 'Se connecter', icon: Icons.login, isLoading: _isLoading, onPressed: _verifyCode),
      const SizedBox(height: 8),
      Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          TextButton(onPressed: _isLoading ? null : _changeEmail, child: const Text('Changer d\'email')),
          TextButton(onPressed: _isLoading ? null : _resendCode, child: const Text('Renvoyer le code')),
        ],
      ),
    ];
  }
}

/// The green header of the login card, in the style of the management page headers.
class _Header extends StatelessWidget {
  const _Header({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = switch (step) {
      _Step.email => 'Saisissez votre email, nous vous envoyons un code de connexion.',
      _Step.newAccount => 'Première visite : quelques informations pour créer votre compte.',
      _Step.code => 'Saisissez le code reçu par email.',
    };
    return Container(
      color: ManagementColors.deepGreen,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connexion', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.icon, required this.isLoading, required this.onPressed});

  final String label;
  final IconData icon;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(backgroundColor: ManagementColors.green, padding: const EdgeInsets.symmetric(vertical: 14)),
      onPressed: isLoading ? null : onPressed,
      icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ManagementColors.cancelled.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ManagementColors.cancelled.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: ManagementColors.cancelled, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ManagementColors.cancelled)),
          ),
        ],
      ),
    );
  }
}
