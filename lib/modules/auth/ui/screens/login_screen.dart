// login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/input_validator.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/core/widgets/custom_text_field.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/auth/cubit/auth_cubit.dart';
import 'package:math_corn/modules/auth/ui/widgets/auth_header.dart';
import 'package:math_corn/modules/main/ui/screens/main_screen.dart';
import 'package:sizer/sizer.dart';

import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Close any open dialogs
        if (state.status == AuthStatus.authenticated) {
          context.pop();
          context.pushAndRemove(const MainScreen());
        } else if (state.status == AuthStatus.loading) {
          showLoadingDialog(context);
        } else if (state.status == AuthStatus.exception &&
            state.exception != null) {
          showErrorDialog(context, state.exception!);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const AuthHeaderWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 3.h),
                        Text(
                          l10n.welcomeBack,
                          style: theme.textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          l10n.signInToContinue,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.h),
                        CustomTextField(
                          label: l10n.email,
                          hint: l10n.enterYourEmail,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) =>
                              InputValidator.validateEmailWithL10n(value, l10n),
                        ),
                        SizedBox(height: 2.h),
                        CustomTextField(
                          label: l10n.password,
                          hint: l10n.enterYourPassword,
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) =>
                              InputValidator.validatePasswordForLoginWithL10n(
                                value,
                                l10n,
                              ),
                        ),
                        SizedBox(height: 1.h),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              context.push(const ForgotPasswordScreen());
                            },
                            child: Text(l10n.forgotPassword),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        CustomButton(
                          text: l10n.signIn,
                          onPressed: () => _login(context),
                          isLoading: false,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.dontHaveAccount,
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.push(const RegisterScreen());
                              },
                              child: Text(l10n.signUp),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      context.read<AuthCubit>().loginWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }
}
