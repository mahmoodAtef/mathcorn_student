import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/input_validator.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/core/widgets/custom_dropdown.dart';
import 'package:math_corn/core/widgets/custom_text_field.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/auth/cubit/auth_cubit.dart';
import 'package:math_corn/modules/auth/data/models/student_creation_form.dart';
import 'package:math_corn/modules/auth/ui/widgets/auth_header.dart';
import 'package:math_corn/modules/main/data/models/grade.dart';
import 'package:math_corn/modules/main/ui/screens/main_screen.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _studentPhoneController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  String?
  _selectedGradeId; // تم تغييرها من int? _selectedGrade إلى String? _selectedGradeId

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _studentPhoneController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Close any open dialogs
        context.pop();

        if (state.status == AuthStatus.authenticated) {
          context.pushAndRemove(MainScreen());
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
                        SizedBox(height: 2.h),
                        Text(
                          l10n.createYourAccount,
                          style: theme.textTheme.displaySmall,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3.h),
                        CustomTextField(
                          label: l10n.fullName,
                          hint: l10n.enterFullName,
                          controller: _nameController,
                          prefixIcon: Icons.person_outline,
                          autofillHints: const [AutofillHints.name],
                          validator: (value) =>
                              InputValidator.validateNameWithL10n(value, l10n),
                        ),
                        SizedBox(height: 2.h),
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
                          label: l10n.studentPhone,
                          hint: l10n.enterStudentPhone,
                          controller: _studentPhoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          validator: (value) =>
                              InputValidator.validateStudentPhoneWithL10n(
                                value,
                                l10n,
                              ),
                        ),
                        SizedBox(height: 2.h),
                        CustomTextField(
                          label: l10n.parentPhone,
                          hint: l10n.enterParentPhone,
                          controller: _parentPhoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.contact_phone_outlined,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          validator: (value) =>
                              InputValidator.validateParentPhoneWithL10n(
                                value,
                                l10n,
                              ),
                        ),
                        SizedBox(height: 2.h),
                        CustomDropdown<String>(
                          // تم تغييرها من <int> إلى <String>
                          label: l10n.grade,
                          hint: l10n.selectYourGrade,
                          value: _selectedGradeId,
                          // تم تغييرها من _selectedGrade إلى _selectedGradeId
                          prefixIcon: Icons.school_outlined,
                          items: _getGradeItems(),
                          // تم تحديث الدالة
                          onChanged: (value) {
                            setState(() {
                              _selectedGradeId =
                                  value; // تم تغييرها من _selectedGrade إلى _selectedGradeId
                            });
                          },
                          validator: (value) =>
                              InputValidator.validateGradeIdWithL10n(
                                value,
                                l10n,
                              ), // تم تحديث validator
                        ),
                        SizedBox(height: 2.h),
                        CustomTextField(
                          label: l10n.password,
                          hint: l10n.enterYourPassword,
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: (value) =>
                              InputValidator.validatePasswordWithL10n(
                                value,
                                l10n,
                              ),
                        ),
                        SizedBox(height: 2.h),
                        CustomTextField(
                          label: l10n.confirmPassword,
                          hint: l10n.confirmYourPassword,
                          controller: _confirmPasswordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                          validator: (value) =>
                              InputValidator.validateConfirmPasswordWithL10n(
                                value,
                                _passwordController.text,
                                l10n,
                              ),
                        ),
                        SizedBox(height: 3.h),
                        CustomButton(
                          text: l10n.createAccount,
                          onPressed: () => _register(context),
                          isLoading: false,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.alreadyHaveAccount,
                              style: theme.textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text(l10n.signIn),
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

  List<DropdownMenuItem<String>> _getGradeItems() {
    return GradeData.availableGrades.map((grade) {
      return DropdownMenuItem<String>(value: grade.id, child: Text(grade.name));
    }).toList();
  }

  void _register(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      final studentForm = StudentCreationForm(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        studentPhone: _studentPhoneController.text.trim(),
        parentPhone: _parentPhoneController.text.trim(),
        gradeId: _selectedGradeId!,
        // تم تغييرها من grade إلى gradeId
        password: _passwordController.text,
      );

      context.read<AuthCubit>().registerWithEmailAndPassword(studentForm);
    }
  }
}
