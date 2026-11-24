import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_spacing.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/validation/validators.dart';
import '../../../../core/widgets/accent_title.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/state_views.dart';
import '../cubit/login_cubit.dart';

/// Log in. Fields are checked as the user types; the password is only
/// checked for being filled in (its length rule belongs to sign up).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscured = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().submit(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _PolaroidHeader(),
                  Padding(
                    padding: AppSpacing.screen,
                    child: AutofillGroup(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const AccentTitle(before: 'Memories ', accent: 'Archive', size: 36),
                            AppGap.h10,
                            Text(
                              "Every place you've been and every moment there, kept in one private album.",
                              style: AppTextStyles.body(size: 16, color: AppColors.muted, height: 1.4),
                            ),
                            AppGap.h24,
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
                              onChanged: (_) => context.read<LoginCubit>().clearError(),
                            ),
                            AppGap.h16,
                            AppTextField(
                              label: 'Password',
                              controller: _password,
                              hint: 'Your password',
                              obscureText: _obscured,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              validator: Validators.required('Enter your password'),
                              serverError: state.fieldError('password'),
                              onChanged: (_) => context.read<LoginCubit>().clearError(),
                              onSubmitted: (_) => _submit(),
                              suffix: PasswordVisibilityButton(
                                obscured: _obscured,
                                onPressed: () => setState(() => _obscured = !_obscured),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: AppButton(
                                label: 'Forgot password?',
                                variant: AppButtonVariant.text,
                                expand: false,
                                onPressed: () => context.push(AppRoutes.forgotPassword),
                              ),
                            ),
                            if (state.bannerMessage != null) ...[
                              FormErrorBanner(message: state.bannerMessage!),
                              AppGap.h12,
                            ],
                            AppButton(
                              label: 'Log in',
                              isLoading: state.isSubmitting,
                              onPressed: _submit,
                            ),
                            AppGap.h20,
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  'New here?',
                                  style: AppTextStyles.body(color: AppColors.muted),
                                ),
                                AppButton(
                                  label: 'Create an account',
                                  variant: AppButtonVariant.text,
                                  expand: false,
                                  onPressed: () => context.push(AppRoutes.register),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Three tilted polaroids at the top of the log in screen.
class _PolaroidHeader extends StatelessWidget {
  const _PolaroidHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: width * 0.07,
                top: 58,
                child: const PolaroidPhoto(
                  image: AssetPaths.loginPolaroidLeft,
                  size: 104,
                  angleDegrees: -7,
                ),
              ),
              Positioned(
                right: width * 0.05,
                top: 66,
                child: const PolaroidPhoto(
                  image: AssetPaths.loginPolaroidRight,
                  size: 98,
                  angleDegrees: 6,
                ),
              ),
              Positioned(
                left: (width - 136) / 2,
                top: 28,
                child: const PolaroidPhoto(
                  image: AssetPaths.loginPolaroidCenter,
                  size: 120,
                  caption: 'dahab, 2023',
                  angleDegrees: -1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
