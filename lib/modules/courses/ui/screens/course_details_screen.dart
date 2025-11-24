import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/extentions/string_direction_extention.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/widgets/custom_button.dart';
import 'package:math_corn/core/widgets/image_builders.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/course.dart';
import 'package:math_corn/modules/courses/data/models/lecture.dart';
import 'package:math_corn/modules/courses/ui/screens/lecture_details_screen.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:sizer/sizer.dart';

class CourseDetailsScreen extends StatelessWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentCubit, StudentState>(
      bloc: context.read<StudentCubit>(),
      builder: (context, state) {
        StudentCubit studentCubit = context.read<StudentCubit>()..getProfile();
        StudentState studentState = studentCubit.state;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, state),
              SliverToBoxAdapter(
                child: _buildCourseContent(context, studentState),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomActionBar(context, state),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, StudentState state) {
    final theme = Theme.of(context);
    final isEnrolled = state.student?.isEnrolled(course.id) ?? false;

    return SliverAppBar(
      expandedHeight: 30.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          course.name,
          textDirection: course.name.getDirection,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            course.image != null
                ? Hero(
                    tag: course.id,
                    transitionOnUserGestures: true,
                    child: Image.network(
                      course.image!,
                      fit: BoxFit.cover,
                      errorBuilder: defaultImageErrorBuilder,
                    ),
                  )
                : Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 15.h,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Status Badge
            if (isEnrolled)
              Positioned(
                top: 10.h,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 4.w,
                        color: theme.colorScheme.onPrimary,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        S.of(context).enrolled,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseContent(BuildContext context, StudentState state) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCourseInfo(
            context,
            state.student?.isEnrolled(course.id) ?? false,
          ),
          SizedBox(height: 3.h),
          _buildCourseDescription(context),

          SizedBox(height: 3.h),
          _buildLecturesList(context, state),
          SizedBox(height: 10.h), // Space for bottom action bar
        ],
      ),
    );
  }

  Widget _buildCourseInfo(BuildContext context, bool isEnrolled) {
    final theme = Theme.of(context);
    final hasDiscount =
        course.newPrice != null && course.newPrice! < course.oldPrice;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  context,
                  Icons.people_outline,
                  '${course.subscribers}',
                  S.of(context).students,
                  theme.colorScheme.primary,
                ),
                Container(height: 4.h, width: 1, color: theme.dividerColor),
                _buildInfoItem(
                  context,
                  Icons.play_lesson_outlined,
                  '${course.lectures.length}',
                  S.of(context).lectures,
                  theme.colorScheme.secondary,
                ),
                // Container(height: 4.h, width: 1, color: theme.dividerColor),
                // _buildInfoItem(
                //   context,
                //   Icons.timer_outlined,
                //   '${_calculateTotalDuration()}',
                //   S.of(context).hours,
                //   theme.colorScheme.tertiary,
                // ),
              ],
            ),
            if (hasDiscount && !isEnrolled) ...[
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer,
                      color: theme.colorScheme.error,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${S.of(context).save} ${(course.oldPrice - course.newPrice!).toStringAsFixed(0)} ${S.of(context).currency}',
                      textDirection: course.name.getDirection,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 6.w),
        SizedBox(height: 1.h),
        Text(
          value,
          textDirection: value.getDirection,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          textDirection: label.getDirection,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseDescription(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  S.of(context).courseDescription,
                  textDirection: S.of(context).courseDescription.getDirection,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              course.description,
              textDirection: course.description.getDirection,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLecturesList(BuildContext context, StudentState state) {
    final theme = Theme.of(context);
    final isEnrolled = state.student?.isEnrolled(course.id) ?? false;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_lesson_outlined,
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  S.of(context).courseLectures,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${course.lectures.length} ${S.of(context).lectures}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: course.lectures.length,
              separatorBuilder: (context, index) => Divider(height: 2.h),
              itemBuilder: (context, index) {
                final lecture = course.lectures[index];
                return _buildLectureItem(
                  context,
                  lecture,
                  index + 1,
                  isEnrolled,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureItem(
    BuildContext context,
    Lecture lecture,
    int index,
    bool isEnrolled,
  ) {
    final theme = Theme.of(context);
    final hasExam = lecture.examId != null;
    final hasFile = lecture.fileUrl != null;

    return InkWell(
      onTap: isEnrolled ? () => _navigateToLecture(lecture, context) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isEnrolled
              ? Colors.transparent
              : theme.colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor, width: 0.5),
        ),
        child: Row(
          children: [
            // Lecture Number
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isEnrolled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isEnrolled
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),

            // Lecture Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lecture.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isEnrolled
                          ? null
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Icon(
                        _getContentTypeIcon(lecture.contentType),
                        size: 4.w,
                        color: theme.colorScheme.secondary,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _getContentTypeLabel(context, lecture.contentType),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      if (hasExam) ...[
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.quiz_outlined,
                          size: 4.w,
                          color: theme.colorScheme.tertiary,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          S.of(context).exam,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                      if (hasFile) ...[
                        SizedBox(width: 3.w),
                        Icon(
                          Icons.attach_file,
                          size: 4.w,
                          color: theme.colorScheme.tertiary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Access Icon
            Icon(
              isEnrolled ? Icons.play_circle_filled : Icons.lock_outlined,
              color: isEnrolled
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 6.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, StudentState state) {
    final theme = Theme.of(context);
    final isEnrolled = state.student?.isEnrolled(course.id) ?? false;
    final isInCart = state.student?.cart?.contains(course.id) ?? false;
    final hasDiscount =
        course.newPrice != null && course.newPrice! < course.oldPrice;
    final price = hasDiscount ? course.newPrice! : course.oldPrice;

    if (!isEnrolled) {
      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Price Section
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasDiscount) ...[
                    Text(
                      '${course.oldPrice.toStringAsFixed(0)} ${S.of(context).currency}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${price.toStringAsFixed(0)} ${S.of(context).currency}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 4.w),

            // Action Button
            Expanded(
              flex: 3,
              child: isInCart
                  ? CustomButton(
                      text: S.of(context).removeFromCart,
                      type: ButtonType.outlined,
                      icon: Icons.remove_shopping_cart,
                      onPressed: () => _removeFromCart(context),
                    )
                  : CustomButton(
                      text: S.of(context).addToCart,
                      icon: Icons.add_shopping_cart,
                      onPressed: () => _addToCart(context),
                    ),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  IconData _getContentTypeIcon(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'video':
        return Icons.play_circle_outline;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.play_circle_outline;
    }
  }

  String _getContentTypeLabel(BuildContext context, String contentType) {
    switch (contentType.toLowerCase()) {
      case 'video':
        return S.of(context).video;
      case 'pdf':
        return 'PDF';
      case 'audio':
        return S.of(context).audio;
      default:
        return S.of(context).content;
    }
  }

  void _navigateToLecture(Lecture lecture, BuildContext context) {
    context.push(LectureContentScreen(lecture: lecture));
    print('Navigate to lecture: ${lecture.name}');
  }

  void _addToCart(BuildContext context) {
    // Add course to cart logic
    final student = context.read<StudentCubit>().state.student;
    if (student != null) {
      final updatedCart = List<String>.from(student.cart ?? []);
      if (!updatedCart.contains(course.id)) {
        updatedCart.add(course.id);
        final updatedStudent = student.copyWith(cart: updatedCart);
        context.read<StudentCubit>().updateProfile(student: updatedStudent);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).courseAddedToCart),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: S.of(context).undo,
              textColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () => _removeFromCart(context),
            ),
          ),
        );
      }
    }
  }

  void _removeFromCart(BuildContext context) {
    // Remove course from cart logic
    final student = context.read<StudentCubit>().state.student;
    if (student != null && student.cart != null) {
      final updatedCart = List<String>.from(student.cart!);
      updatedCart.remove(course.id);
      final updatedStudent = student.copyWith(cart: updatedCart);
      context.read<StudentCubit>().updateProfile(student: updatedStudent);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).courseRemovedFromCart),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
