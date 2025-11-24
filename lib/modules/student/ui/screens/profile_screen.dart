import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/error/exception_manager.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/services/input_validator.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/library/cubit/library_cubit.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:math_corn/modules/student/ui/screens/edit_profile_screen.dart';
import 'package:math_corn/modules/student/ui/widgets/profile_info_card.dart';
import 'package:math_corn/modules/student/ui/widgets/profile_stats.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().getProfile();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider<LibraryCubit>(
      create: (context) => sl<LibraryCubit>(),
      child: Builder(
        builder: (builderContext) {
          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: BlocConsumer<StudentCubit, StudentState>(
              listener: (context, state) {
                if (state.isError) {
                  ExceptionManager.showMessage(state.exception!);
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const CustomLoadingWidget();
                }

                if (state.isError) {
                  return CustomErrorWidget(
                    exception: state.exception!,
                    height: 80.h,
                  );
                }

                if (state.student == null) {
                  return const NoDataWidget();
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<StudentCubit>().getProfile(),
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                  child: CustomScrollView(
                    slivers: [
                      // Custom App Bar with gradient
                      SliverAppBar(
                        expandedHeight: 35.h,
                        floating: false,
                        pinned: true,
                        elevation: 0,
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withOpacity(0.9),
                                  colorScheme.secondary.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: _buildEnhancedProfileHeader(
                                  state,
                                  colorScheme,
                                ),
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          Container(
                            margin: EdgeInsets.only(right: 4.w, top: 1.h),
                            decoration: BoxDecoration(
                              color: colorScheme.onPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.onPrimary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(colorScheme),
                              icon: Icon(
                                Icons.delete_outline,
                                color: colorScheme.onPrimary,
                              ),
                              tooltip: S.of(context).deleteAccount,
                            ),
                          ),
                        ],
                      ),

                      // Body Content
                      SliverToBoxAdapter(
                        child: Transform.translate(
                          offset: const Offset(0, -30),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Column(
                                  children: [
                                    // Stats Card with enhanced design
                                    _buildEnhancedStatsCard(
                                      state,
                                      colorScheme,
                                      context,
                                    ),
                                    SizedBox(height: 3.h),

                                    // Profile Information with modern cards
                                    _buildModernProfileInfo(state, colorScheme),
                                    SizedBox(height: 3.h),

                                    // Action Buttons with enhanced styling
                                    _buildActionButtons(state, colorScheme),
                                    SizedBox(height: 4.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedProfileHeader(
    StudentState state,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 3.h),
          // Profile Avatar with glow effect
          Flexible(
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    colorScheme.onPrimary,
                    colorScheme.onPrimary.withOpacity(0.9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onPrimary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  state.student!.name.isNotEmpty
                      ? state.student!.name[0].toUpperCase()
                      : 'U',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          Text(
            state.student!.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimary,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),

          // Email with subtle styling
          Text(
            state.student!.email,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onPrimary.withOpacity(0.9),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.5.h),

          // Grade badge with modern design - استخدام gradeName بدلاً من grade
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: colorScheme.onPrimary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.school, color: colorScheme.onPrimary, size: 18),
                SizedBox(width: 2.w),
                Text(
                  state.student!.gradeName, // استخدام gradeName بدلاً من الرقم
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatsCard(
    StudentState state,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(2, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          ProfileStatsWidget(
            onGoing: state.student!.onGoing,
            cart: state.student!.cart,
            savedVideos: context.read<LibraryCubit>().state.lectures.length,
          ),
        ],
      ),
    );
  }

  Widget _buildModernProfileInfo(StudentState state, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 3.h,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                S.of(context).contactInformation,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),

        // Enhanced ProfileInfoCard with animation
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ProfileInfoCard(
            title: S.of(context).studentPhone,
            value: state.student!.studentPhone,
            icon: Icons.phone,
          ),
        ),
        SizedBox(height: 1.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: ProfileInfoCard(
            title: S.of(context).parentPhone,
            value: state.student!.parentPhone,
            icon: Icons.contact_phone,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(StudentState state, ColorScheme colorScheme) {
    return Column(
      children: [
        // Edit Profile Button with gradient
        Container(
          width: double.infinity,
          height: 6.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => _navigateToEditProfile(state),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      S.of(context).editProfile,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
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

  void _navigateToEditProfile(StudentState state) {
    context.push(EditProfileScreen(student: state.student!));
  }

  void _showDeleteConfirmationDialog(ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colorScheme.error),
            SizedBox(width: 2.w),
            Text(
              S.of(context).deleteAccount,
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ],
        ),
        content: Text(
          S.of(context).deleteAccountConfirmation,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(S.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteAccountForm(colorScheme);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(S.of(context).delete),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountForm(ColorScheme colorScheme) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          S.of(context).confirmDelete,
          style: TextStyle(color: colorScheme.onSurface),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).enterCredentialsToDelete,
                style: TextStyle(color: colorScheme.onSurface),
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: emailController,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: S.of(context).email,
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.email,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) =>
                    InputValidator.validateEmailWithL10n(value, S.of(context)),
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: S.of(context).password,
                  labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) =>
                    InputValidator.validatePasswordForLoginWithL10n(
                      value,
                      S.of(context),
                    ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(S.of(context).cancel),
          ),
          BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          context.read<StudentCubit>().deleteProfile(
                            email: emailController.text.trim(),
                            password: passwordController.text,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: state.isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.onError,
                          ),
                        ),
                      )
                    : Text(S.of(context).deleteAccount),
              );
            },
          ),
        ],
      ),
    );
  }
}
