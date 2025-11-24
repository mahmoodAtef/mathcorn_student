import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/cubit/courses_cubit.dart';
import 'package:math_corn/modules/courses/data/models/course.dart';
import 'package:math_corn/modules/payment/ui/screens/checkout_screen.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:sizer/sizer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  void _loadCartData() {
    final studentState = context.read<StudentCubit>().state;
    if (studentState.student != null) {
      context.read<CoursesCubit>().getCourses(
        grade: studentState.student!.gradeId,
        forceRefresh: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Scaffold(
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, studentState) {
          if (studentState.status == StudentStatus.loading) {
            return const CustomLoadingWidget();
          }

          if (studentState.status == StudentStatus.error) {
            return CustomErrorWidget(exception: studentState.exception!);
          }

          final student = studentState.student;
          if (student == null ||
              student.cart == null ||
              student.cart!.isEmpty) {
            return _buildEmptyCart(context);
          }

          return BlocBuilder<CoursesCubit, CoursesState>(
            buildWhen: (previous, current) =>
                previous.courses != current.courses,
            builder: (context, coursesState) {
              if (coursesState.status == CoursesStatus.loading) {
                return const CustomLoadingWidget();
              }

              final cartCourses = _getCartCourses(
                student.cart!,
                coursesState.courses ?? [],
              );

              return _buildCartContent(context, cartCourses);
            },
          );
        },
      ),
    );
  }

  List<Course> _getCartCourses(List<String> cartIds, List<Course> allCourses) {
    return allCourses
        .where((course) => cartIds.contains(course.id))
        .toSet()
        .toList();
  }

  Widget _buildEmptyCart(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return CustomScrollView(
      slivers: [
        _buildCartHeader(context),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 20.w,
                    color: theme.colorScheme.outline,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    l10n.emptyCart,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    l10n.addCoursesToCart,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartContent(BuildContext context, List<Course> cartCourses) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return CustomScrollView(
      slivers: [
        _buildCartHeader(context),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.cartItems,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cartCourses.length}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final course = cartCourses[index];
              return _buildCourseCard(context, course);
            }, childCount: cartCourses.length),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: _buildCheckoutSection(context, cartCourses),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 10.h)),
      ],
    );
  }

  Widget _buildCartHeader(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return SliverAppBar(
      expandedHeight: 25.h,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          l10n.cart,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.surface,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.shopping_cart,
              size: 15.w,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return Card(
      margin: EdgeInsets.only(bottom: 3.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            // Course Image/Icon
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: course.image != null && course.image!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        course.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.play_circle_filled,
                          color: theme.colorScheme.primary,
                          size: 8.w,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.play_circle_filled,
                      color: theme.colorScheme.primary,
                      size: 8.w,
                    ),
            ),
            SizedBox(width: 4.w),

            // Course Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: BlocBuilder<StudentCubit, StudentState>(
                          builder: (context, state) {
                            final gradeName =
                                state.student?.gradeName ?? l10n.unknown;
                            return Text(
                              gradeName,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '• ${course.lectures?.length ?? 0} ${l10n.lectures}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '${course.newPrice ?? course.oldPrice ?? 0} ${l10n.currency}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Remove Button
            IconButton(
              onPressed: () => _removeFromCart(context, course.id),
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.error,
                size: 6.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, List<Course> cartCourses) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    final totalPrice = cartCourses.fold<double>(
      0.0,
      (sum, course) => sum + (course.newPrice ?? course.oldPrice ?? 0.0),
    );

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.totalCourses, style: theme.textTheme.titleMedium),
              Text(
                '${cartCourses.length}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalPrice,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${totalPrice.toStringAsFixed(0)} ${l10n.currency}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Checkout Button
          CustomButton(
            text: l10n.proceedToCheckout,
            onPressed: cartCourses.isNotEmpty
                ? () => _proceedToCheckout(context, cartCourses)
                : null,
            icon: Icons.payment,
            height: 7.h,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _removeFromCart(BuildContext context, String courseId) {
    final l10n = S.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            l10n.removeFromCart,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(l10n.confirmRemoveFromCart),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                context.read<StudentCubit>().removeCourseFromCart(courseId);
                dialogContext.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.removedFromCart),
                    backgroundColor: theme.colorScheme.error,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                l10n.remove,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _proceedToCheckout(BuildContext context, List<Course> courses) {
    context.push(
      CheckoutScreen(
        cartCourses: courses,
        totalPrice: courses.fold<double>(
          0.0,
          (sum, course) => sum + (course.newPrice ?? course.oldPrice ?? 0.0),
        ),
      ),
    );
  }
}
