import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/error/exception_manager.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/input_validator.dart';
import 'package:math_corn/core/widgets/custom_dropdown.dart';
import 'package:math_corn/core/widgets/custom_text_field.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/main/data/models/grade.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:math_corn/modules/student/data/models/student.dart';
import 'package:sizer/sizer.dart';

class EditProfileScreen extends StatefulWidget {
  final StudentProfile student;

  const EditProfileScreen({super.key, required this.student});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _studentPhoneController;
  late final TextEditingController _parentPhoneController;
  late final TextEditingController _emailController;
  late String
  _selectedGradeId; // تم تغييرها من int _selectedGrade إلى String _selectedGradeId

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.student.name);
    _studentPhoneController = TextEditingController(
      text: widget.student.studentPhone,
    );
    _parentPhoneController = TextEditingController(
      text: widget.student.parentPhone,
    );
    _emailController = TextEditingController(text: widget.student.email);
    _selectedGradeId =
        widget.student.gradeId; // تم تغييرها من grade إلى gradeId

    // Listen for changes
    _nameController.addListener(_onDataChanged);
    _studentPhoneController.addListener(_onDataChanged);
    _parentPhoneController.addListener(_onDataChanged);
    _emailController.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    final hasChanges =
        _nameController.text != widget.student.name ||
        _studentPhoneController.text != widget.student.studentPhone ||
        _parentPhoneController.text != widget.student.parentPhone ||
        _selectedGradeId !=
            widget.student.gradeId || // تم تغييرها من grade إلى gradeId
        _emailController.text != widget.student.email;

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _studentPhoneController.dispose();
    _parentPhoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(S.of(context).editProfile),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        actions: [
          BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.only(right: 4.w),
                child: TextButton.icon(
                  onPressed: (_hasChanges && !state.isLoading)
                      ? _saveProfile
                      : null,
                  icon: state.isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.save,
                          size: 18,
                          color: _hasChanges
                              ? colorScheme.onPrimary
                              : colorScheme.onPrimary.withOpacity(0.5),
                        ),
                  label: Text(
                    S.of(context).saveChanges,
                    style: TextStyle(
                      color: _hasChanges
                          ? colorScheme.onPrimary
                          : colorScheme.onPrimary.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<StudentCubit, StudentState>(
        listener: (context, state) {
          if (state.isError) {
            ExceptionManager.showMessage(state.exception!);
          } else if (state.isGotProfile) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  S.of(context).profileUpdatedSuccessfully,
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                backgroundColor: colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            context.pop();
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withOpacity(0.05),
                  colorScheme.surface,
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Profile Avatar Section
                    _buildProfileAvatar(colorScheme),
                    SizedBox(height: 4.h),

                    // Basic Information Section
                    _buildSectionTitle(
                      S.of(context).personalInfo,
                      Icons.person_outline,
                      colorScheme,
                    ),
                    SizedBox(height: 2.h),

                    _buildInfoCard(
                      colorScheme,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: S.of(context).fullName,
                            hint: S.of(context).enterFullName,
                            prefixIcon: Icons.person,
                            controller: _nameController,
                            validator: (value) =>
                                InputValidator.validateNameWithL10n(
                                  value,
                                  S.of(context),
                                ),
                            enabled: !state.isLoading,
                          ),
                          SizedBox(height: 2.h),
                          // email
                          CustomTextField(
                            label: S.of(context).email,
                            hint: S.of(context).enterYourEmail,
                            prefixIcon: Icons.email_outlined,
                            controller: _emailController,
                            validator: (value) =>
                                InputValidator.validateEmailWithL10n(
                                  value,
                                  S.of(context),
                                ),
                            enabled: false,
                          ),
                          SizedBox(height: 2.h),

                          CustomDropdown<String>(
                            // تم تغييرها من <int> إلى <String>
                            label: S.of(context).grade,
                            hint: S.of(context).selectYourGrade,
                            prefixIcon: Icons.school,
                            value: _selectedGradeId,
                            // تم تغييرها من _selectedGrade إلى _selectedGradeId
                            items: _buildGradeItems(),
                            // تم تحديث الدالة
                            onChanged: state.isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _selectedGradeId =
                                          value!; // تم تغييرها من _selectedGrade إلى _selectedGradeId
                                    });
                                    _onDataChanged();
                                  },
                            validator: (value) =>
                                InputValidator.validateGradeIdWithL10n(
                                  value,
                                  S.of(context),
                                ),
                            enabled: !state.isLoading,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Contact Information Section
                    _buildSectionTitle(
                      S.of(context).contactInformation,
                      Icons.contact_phone_outlined,
                      colorScheme,
                    ),
                    SizedBox(height: 2.h),

                    _buildInfoCard(
                      colorScheme,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: S.of(context).studentPhone,
                            hint: S.of(context).enterStudentPhone,
                            prefixIcon: Icons.phone,
                            controller: _studentPhoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                InputValidator.validateStudentPhoneWithL10n(
                                  value,
                                  S.of(context),
                                ),
                            enabled: !state.isLoading,
                          ),
                          SizedBox(height: 2.h),

                          CustomTextField(
                            label: S.of(context).parentPhone,
                            hint: S.of(context).enterParentPhone,
                            prefixIcon: Icons.contact_phone,
                            controller: _parentPhoneController,
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                InputValidator.validateParentPhoneWithL10n(
                                  value,
                                  S.of(context),
                                ),
                            enabled: !state.isLoading,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Action Buttons
                    _buildActionButtons(state, colorScheme),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(ColorScheme colorScheme) {
    return Center(
      child: Container(
        width: 25.w,
        height: 25.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary.withOpacity(0.8), colorScheme.primary],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            widget.student.name.isNotEmpty
                ? widget.student.name[0].toUpperCase()
                : 'U',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: colorScheme.onPrimary, size: 20),
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ColorScheme colorScheme, {required Widget child}) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActionButtons(StudentState state, ColorScheme colorScheme) {
    return Column(
      children: [
        // Save Changes Button
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            gradient: _hasChanges && !state.isLoading
                ? LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.8),
                    ],
                  )
                : null,
            color: _hasChanges && !state.isLoading
                ? null
                : colorScheme.outline.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            boxShadow: _hasChanges && !state.isLoading
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: (_hasChanges && !state.isLoading) ? _saveProfile : null,
              child: Center(
                child: state.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save,
                            color: _hasChanges && !state.isLoading
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface.withOpacity(0.5),
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            S.of(context).saveChanges,
                            style: TextStyle(
                              color: _hasChanges && !state.isLoading
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),

        // Cancel Button
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: state.isLoading ? null : () => context.pop(),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.close,
                      color: state.isLoading
                          ? colorScheme.onSurface.withOpacity(0.3)
                          : colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      S.of(context).cancel,
                      style: TextStyle(
                        color: state.isLoading
                            ? colorScheme.onSurface.withOpacity(0.3)
                            : colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildGradeItems() {
    return GradeData.availableGrades.map((grade) {
      return DropdownMenuItem<String>(value: grade.id, child: Text(grade.name));
    }).toList();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedStudent = widget.student.copyWith(
      name: _nameController.text.trim(),
      studentPhone: _studentPhoneController.text.trim(),
      parentPhone: _parentPhoneController.text.trim(),
      gradeId: _selectedGradeId, // تم تغييرها من grade إلى gradeId
    );

    context.read<StudentCubit>().updateProfile(student: updatedStudent);
  }
}
