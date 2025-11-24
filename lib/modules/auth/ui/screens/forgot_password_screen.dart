// forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/input_validator.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/core/widgets/custom_text_field.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/auth/cubit/auth_cubit.dart';
import 'package:math_corn/modules/auth/ui/widgets/auth_header.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widgets/core_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // close any open dialogs
        if (context.canPop()) {
          context.pop();
        }
        if (state.status == AuthStatus.forgotPassword) {
          setState(() {
            _isEmailSent = true;
          });
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
                  child: _isEmailSent
                      ? _buildEmailSentContent(theme, l10n)
                      : _buildForgotPasswordForm(theme, l10n, state),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildForgotPasswordForm(ThemeData theme, S l10n, AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 3.h),
          Text(
            l10n.forgotPassword,
            style: theme.textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            l10n.forgotPasswordDescription,
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
          SizedBox(height: 3.h),
          CustomButton(
            text: l10n.sendResetEmail,
            onPressed: () => _sendResetEmail(context),
            isLoading: false,
          ),
          SizedBox(height: 2.h),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.backToSignIn),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildEmailSentContent(ThemeData theme, S l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 5.h),
        Icon(
          Icons.mark_email_read_outlined,
          size: 20.w,
          color: theme.colorScheme.primary,
        ),
        SizedBox(height: 3.h),
        Text(
          l10n.emailSent,
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          l10n.resetEmailSentDescription,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        CustomButton(
          text: l10n.checkYourEmail,
          onPressed: () => context.pop(),
          type: ButtonType.outlined,
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  void _sendResetEmail(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      context.read<AuthCubit>().forgotPassword(_emailController.text.trim());
    }
  }
}
