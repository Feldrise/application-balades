import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _codeController = TextEditingController();

  bool _isLoading = false;
  String? _error;

  // Flow state
  bool _emailChecked = false; // we have called authenticate and now wait for OTP
  bool _existingUser = true; // default assume existing; toggled by precheck
  DateTime? _otpExpiresAt; // to show a countdown

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _precheckEmail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final exists = await AuthenticationService.instance.checkEmailExists(_emailController.text.trim());
      setState(() {
        _existingUser = exists;
      });
    } catch (_) {
      // If check fails, we still can proceed; don't block UX
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await AuthenticationService.instance.authenticate(
        _emailController.text.trim(),
        firstName: _existingUser
            ? null
            : _firstNameController.text.trim().isEmpty
            ? null
            : _firstNameController.text.trim(),
        lastName: _existingUser
            ? null
            : _lastNameController.text.trim().isEmpty
            ? null
            : _lastNameController.text.trim(),
        phone: _existingUser
            ? null
            : _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );
      setState(() {
        _emailChecked = true;
        _otpExpiresAt = DateTime.now().add(const Duration(minutes: 5));
      });
    } catch (e) {
      setState(() => _error = 'Impossible d\'envoyer le code. Vérifiez l\'email.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_codeController.text.trim().length != 6) {
      setState(() => _error = 'Code invalide');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final result = await AuthenticationService.instance.verifyAuthentication(_emailController.text.trim(), _codeController.text.trim());
      if (result.user == null || result.token == null) {
        throw Exception('Réponse invalide du serveur');
      }
      await ref.read(authenticationProvider.notifier).login(AuthedUser(user: result.user!, token: result.token!));
      if (mounted) context.go('/mes-reservations');
    } catch (e) {
      setState(() => _error = 'Code invalide ou expiré');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Connectez-vous pour voir vos inscriptions', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      if (_error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: theme.colorScheme.error.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
                          child: Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                        ),
                        const SizedBox(height: 12),
                      ],
                      // Step 1: email entry
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || v.isEmpty) ? 'Email requis' : null,
                        onChanged: (_) {
                          // Reset state if email changes
                          setState(() {
                            _emailChecked = false;
                            _otpExpiresAt = null;
                          });
                        },
                      ),

                      if (!_emailChecked) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            OutlinedButton.icon(onPressed: _isLoading ? null : _precheckEmail, icon: const Icon(Icons.search), label: const Text('Vérifier l\'email')),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: _isLoading ? null : _requestOtp,
                              icon: _isLoading
                                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.mail),
                              label: Text(_isLoading ? 'Envoi...' : 'Recevoir un code'),
                            ),
                          ],
                        ),
                      ],

                      // For new users, request extra fields
                      if (!_existingUser && !_emailChecked) ...[
                        const SizedBox(height: 16),
                        Text('Nouveau compte', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(labelText: 'Prénom (requis)', prefixIcon: Icon(Icons.person_outline)),
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Prénom requis' : null,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(labelText: 'Nom (optionnel)'),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Téléphone (optionnel)'),
                          keyboardType: TextInputType.phone,
                        ),
                      ],

                      // Step 2: OTP entry
                      if (_emailChecked) ...[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.sms),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _otpExpiresAt == null
                                    ? 'Un code à 6 chiffres a été envoyé par email.'
                                    : 'Entrez le code (expire à ${TimeOfDay.fromDateTime(_otpExpiresAt!).format(context)})',
                              ),
                            ),
                            TextButton(onPressed: _isLoading ? null : _requestOtp, child: const Text('Renvoyer')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _codeController,
                          decoration: const InputDecoration(labelText: 'Code à 6 chiffres'),
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          onSubmitted: (_) => _verifyOtp(),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: _isLoading ? null : _verifyOtp,
                          icon: _isLoading
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.verified_user),
                          label: Text(_isLoading ? 'Vérification...' : 'Se connecter'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
