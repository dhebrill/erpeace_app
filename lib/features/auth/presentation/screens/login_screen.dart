import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/content_width.dart';
import '../providers/auth_controller.dart';
import '../widgets/auth_brand_header.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final auth = ref.watch(authControllerProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        AppSnackBar.showError(context, message);
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              scheme.primaryContainer.withValues(alpha: 0.55),
              scheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.xxxl,
            ),
            child: ContentWidth(
              maxWidth: 460,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthBrandHeader(),
                    const SizedBox(height: AppSpacing.xxl),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'nama@bisnis.com',
                      prefixIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.none,
                      autofillHints: const [AutofillHints.email],
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Kata sandi',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      validator: Validators.password,
                      onSubmitted: (_) => _submit(),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Tampilkan kata sandi'
                            : 'Sembunyikan kata sandi',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            GoRouter.of(context).go(AppRoutes.forgotPassword),
                        child: const Text('Lupa kata sandi?'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton(
                      onPressed: auth.isSubmitting ? null : _submit,
                      child: auth.isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Masuk'),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              GoRouter.of(context).go(AppRoutes.register),
                          child: const Text('Daftar'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Hubungi admin untuk aktivasi akun setelah pendaftaran.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
