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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .sendPasswordReset(_emailController.text);
      if (!mounted) return;
      setState(() {
        _sent = true;
        _sending = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _sending = false);
      AppSnackBar.showError(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => GoRouter.of(context).go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.sm,
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
                  const AuthBrandHeader(
                    title: 'Lupa kata sandi',
                    subtitle:
                        'Masukkan email terdaftar, kami akan mengirim tautan untuk mengatur ulang kata sandi.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (_sent)
                    _SentState(email: _emailController.text.trim())
                  else ...[
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'nama@bisnis.com',
                      prefixIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: Validators.email,
                      onSubmitted: (_) => _submit(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton(
                      onPressed: _sending ? null : _submit,
                      child: _sending
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Kirim tautan reset'),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  Center(
                    child: TextButton(
                      onPressed: () => GoRouter.of(context).go(AppRoutes.login),
                      child: const Text('Kembali ke halaman masuk'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SentState extends StatelessWidget {
  const _SentState({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primaryContainer.withValues(alpha: 0.6),
          ),
          child: Icon(
            Icons.mark_email_read_rounded,
            size: 40,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Tautan reset telah dikirim',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Periksa kotak masuk $email untuk melanjutkan pengaturan kata sandi.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
