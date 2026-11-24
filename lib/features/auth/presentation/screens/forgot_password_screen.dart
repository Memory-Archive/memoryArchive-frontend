import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/validation/validators.dart';
import '../../../../core/widgets/accent_title.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/circle_icon_button.dart';
import '../../../../core/widgets/state_views.dart';
import '../cubit/forgot_password_cubit.dart';

/// Forgot password. Calls `POST /auth/forgot-password`. This semester the
/// backend answers 501, so the screen explains that reset isn't available
/// yet instead of showing an error.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ForgotPasswordCubit>().submit(_email.text);
  }

  void _back() => context.canPop() ? context.pop() : context.go(AppRoutes.login);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleIconButton(
                      icon: Icons.arrow_back_ios_new,
                      tooltip: 'Back to log in',
                      onPressed: _back,
                    ),
                  ),
                  AppGap.h32,
                  switch (state.status) {
                    ForgotPasswordStatus.sent => _ResultPanel(
                        icon: Icons.mark_email_read_outlined,
                        title: 'Check your inbox',
                        message:
                            'If an account uses that email, a reset link is waiting there. It works once.',
                        onBack: _back,
                        onRetry: () => context.read<ForgotPasswordCubit>().reset(),
                        retryLabel: "Didn't get it? Send again",
                      ),
                    ForgotPasswordStatus.unavailable => _ResultPanel(
                        icon: Icons.schedule_outlined,
                        title: 'Not available yet',
                        message:
                            'Password reset is coming in the next version. If you remember your password, go back and log in.',
                        onBack: _back,
                      ),
                    _ => _buildForm(context, state),
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ForgotPasswordState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(Icons.lock_outline, size: 40, color: AppColors.green),
            ),
          ),
          AppGap.h24,
          const AccentTitle(before: 'Locked out of your ', accent: 'memories?', size: 32),
          AppGap.h10,
          Text(
            "Enter the email you signed up with. We'll send a one-time link to choose a new password.",
            style: AppTextStyles.body(color: AppColors.muted, height: 1.45),
          ),
          AppGap.h24,
          AppTextField(
            label: 'Email',
            controller: _email,
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: Validators.compose([
              Validators.required('Enter your email'),
              Validators.email(),
            ]),
            serverError: state.error?.messageFor('email'),
            onSubmitted: (_) => _submit(),
          ),
          AppGap.h24,
          if (state.status == ForgotPasswordStatus.failure && state.error != null) ...[
            FormErrorBanner(message: state.error!.message),
            AppGap.h12,
          ],
          AppButton(
            label: 'Send reset link',
            isLoading: state.isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.icon,
    required this.title,
    required this.message,
    required this.onBack,
    this.onRetry,
    this.retryLabel,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback onBack;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Transform.rotate(
            angle: -0.035,
            child: Container(
              width: 220,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              decoration: BoxDecoration(
                color: AppColors.card,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.14),
                    blurRadius: 30,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 34, color: AppColors.green),
                  AppGap.h10,
                  Text('a way back in', style: AppTextStyles.hand(size: 24)),
                ],
              ),
            ),
          ),
        ),
        AppGap.h32,
        Text(title, textAlign: TextAlign.center, style: AppTextStyles.display(size: 30)),
        AppGap.h10,
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(color: AppColors.muted, height: 1.45),
        ),
        AppGap.h32,
        AppButton(label: 'Back to log in', onPressed: onBack),
        if (onRetry != null && retryLabel != null) ...[
          AppGap.h8,
          AppButton(label: retryLabel!, variant: AppButtonVariant.text, onPressed: onRetry),
        ],
      ],
    );
  }
}
