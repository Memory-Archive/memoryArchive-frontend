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
import '../cubit/register_cubit.dart';
import '../widgets/password_strength_meter.dart';

/// Create account. Sends `POST /auth/signup`, then logs in automatically.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscured = true;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<RegisterCubit>().submit(
          username: _username.text,
          email: _email.text,
          password: _password.text,
        );
  }

  void _onEdited(String _) => context.read<RegisterCubit>().clearError();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CircleIconButton(
                          icon: Icons.arrow_back_ios_new,
                          tooltip: 'Back to log in',
                          onPressed: () =>
                              context.canPop() ? context.pop() : context.go(AppRoutes.login),
                        ),
                      ),
                      AppGap.h16,
                      const AccentTitle(before: 'Start your ', accent: 'archive', size: 34),
                      AppGap.h8,
                      Text(
                        'Your memories stay private to you.',
                        style: AppTextStyles.body(color: AppColors.muted, height: 1.4),
                      ),
                      AppGap.h20,
                      AppTextField(
                        label: 'Username',
                        controller: _username,
                        hint: 'sara.h',
                        helper: '3 to 30 characters: letters, numbers, dots and underscores',
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newUsername],
                        maxLength: AuthRules.usernameMax,
                        validator: Validators.compose([
                          Validators.required('Choose a username'),
                          Validators.username(),
                        ]),
                        serverError: state.fieldError('username'),
                        onChanged: _onEdited,
                      ),
                      AppGap.h16,
                      AppTextField(
                        label: 'Email',
                        controller: _email,
                        hint: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: Validators.compose([
                          Validators.required('Enter your email'),
                          Validators.email(),
                        ]),
                        serverError: state.fieldError('email'),
                        onChanged: _onEdited,
                      ),
                      AppGap.h16,
                      AppTextField(
                        label: 'Password',
                        controller: _password,
                        hint: 'Choose a password',
                        obscureText: _obscured,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        maxLength: AuthRules.passwordMax,
                        validator: Validators.compose([
                          Validators.required('Choose a password'),
                          Validators.newPassword(),
                        ]),
                        serverError: state.fieldError('password'),
                        onChanged: _onEdited,
                        suffix: PasswordVisibilityButton(
                          obscured: _obscured,
                          plural: true,
                          onPressed: () => setState(() => _obscured = !_obscured),
                        ),
                      ),
                      AppGap.h8,
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _password,
                        builder: (context, value, _) => PasswordStrengthMeter(password: value.text),
                      ),
                      AppGap.h16,
                      AppTextField(
                        label: 'Confirm password',
                        controller: _confirm,
                        hint: 'Type it again',
                        obscureText: _obscured,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: Validators.compose([
                          Validators.required('Type your password again'),
                          Validators.matches(() => _password.text, "Passwords don't match"),
                        ]),
                        onSubmitted: (_) => _submit(),
                      ),
                      AppGap.h12,
                      ListenableBuilder(
                        listenable: Listenable.merge([_password, _confirm]),
                        builder: (context, _) {
                          final length = _password.text.length;
                          return Column(
                            children: [
                              RuleCheck(
                                text: 'At least ${AuthRules.passwordMin} characters. A long phrase works well.',
                                met: length >= AuthRules.passwordMin && length <= AuthRules.passwordMax,
                              ),
                              AppGap.h6,
                              RuleCheck(
                                text: 'Both passwords match',
                                met: _password.text.isNotEmpty && _password.text == _confirm.text,
                              ),
                            ],
                          );
                        },
                      ),
                      AppGap.h24,
                      if (state.bannerMessage != null) ...[
                        FormErrorBanner(message: state.bannerMessage!),
                        AppGap.h12,
                      ],
                      AppButton(
                        label: 'Create account',
                        isLoading: state.isSubmitting,
                        onPressed: _submit,
                      ),
                      AppGap.h12,
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: AppTextStyles.body(color: AppColors.muted),
                          ),
                          AppButton(
                            label: 'Log in',
                            variant: AppButtonVariant.text,
                            expand: false,
                            onPressed: () =>
                                context.canPop() ? context.pop() : context.go(AppRoutes.login),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
