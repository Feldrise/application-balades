import 'package:balade/core/widgets/loading_overlay.dart';
import 'package:balade/features/authentication/authentication_provider.dart';
import 'package:balade/features/authentication/authentication_service.dart';
import 'package:balade/features/authentication/data/models/authed_user/authed_user.dart';
import 'package:balade/themes/screen_helper.dart';
import 'widgets/admin_login_header.dart';
import 'widgets/admin_login_error_message.dart';
import 'widgets/admin_login_email_step.dart';
import 'widgets/admin_login_code_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminLoginPage extends ConsumerStatefulWidget {
  const AdminLoginPage({super.key});

  @override
  ConsumerState<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends ConsumerState<AdminLoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();

  bool _showCodeStep = false;
  bool _obscureCode = true;
  String? _errorMessage;

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _fadeController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
    });

    LoadingOverlay.of(context).show();

    try {
      await AuthenticationService.instance.authenticate(_emailController.text);
      setState(() {
        _showCodeStep = true;
      });
      _slideController.forward();
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Une erreur est survenue';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur inattendue est survenue';
      });
    } finally {
      if (mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = null;
    });

    LoadingOverlay.of(context).show();

    try {
      final result = await AuthenticationService.instance.verifyAuthentication(_emailController.text, _codeController.text);

      if (result.user == null || result.token == null) {
        throw Exception('Invalid response from server');
      }

      final authedUser = AuthedUser(user: result.user!, token: result.token!);
      await ref.read(authenticationProvider.notifier).login(authedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connexion réussie !'), backgroundColor: Colors.green));
        // Navigation will be handled by the parent router
      }
    } on PlatformException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Code invalide';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur inattendue est survenue';
      });
    } finally {
      if (mounted) {
        LoadingOverlay.of(context).hide();
      }
    }
  }

  void _goBack() {
    setState(() {
      _showCodeStep = false;
      _errorMessage = null;
      _codeController.clear();
    });
    _slideController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= ScreenHelper.breakpointPC;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: isDesktop ? 480 : double.infinity,
              margin: EdgeInsets.all(isDesktop ? 0 : 24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AdminLoginHeader(showCodeStep: _showCodeStep),
                        const SizedBox(height: 32),
                        _buildContent(theme),
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

  Widget _buildContent(ThemeData theme) {
    return Column(
      children: [
        if (_errorMessage != null) AdminLoginErrorMessage(errorMessage: _errorMessage!),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showCodeStep
              ? AdminLoginCodeStep(
                  codeController: _codeController,
                  email: _emailController.text,
                  obscureCode: _obscureCode,
                  onVerifyCode: _verifyCode,
                  onGoBack: _goBack,
                  onToggleObscure: () => setState(() => _obscureCode = !_obscureCode),
                  onFieldSubmitted: (_) => _verifyCode(),
                )
              : AdminLoginEmailStep(emailController: _emailController, onSendCode: _sendCode, onFieldSubmitted: (_) => _sendCode()),
        ),
      ],
    );
  }
}
