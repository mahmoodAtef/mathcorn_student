import 'package:flutter/material.dart';
import 'package:math_corn/core/routing/navigation_manager.dart';
import 'package:math_corn/core/widgets/image_builders.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/courses/data/models/course.dart';
import 'package:math_corn/modules/courses/ui/screens/course_details_screen.dart';
import 'package:math_corn/modules/student/data/models/student.dart';
import 'package:sizer/sizer.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final StudentProfile? student;
  final VoidCallback? onEnrollPressed;
  final VoidCallback? onAddToCartPressed;

  const CourseCard({
    super.key,
    required this.course,
    this.student,
    this.onEnrollPressed,
    this.onAddToCartPressed,
  });

  bool get isEnrolled => student?.isEnrolled(course.id) ?? false;

  bool get isInCart => student?.cart?.contains(course.id) ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount =
        course.newPrice != null && course.newPrice! < course.oldPrice;

    return Hero(
      tag: course.id,
      child: Container(
        height: 22.h,
        width: 90.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20), // زيادة البورد راديوس
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => context.push(CourseDetailsScreen(course: course)),
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                // Course Image Section - أصغر
                _buildImageSection(context, theme, hasDiscount),
                // Content Section - محسنة
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildContentSection(theme, context),
                        _buildBottomSection(theme, context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    ThemeData theme,
    bool hasDiscount,
  ) {
    return Expanded(
      flex: 1,
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: course.image != null
                    ? Image.network(
                        course.image!,
                        fit: BoxFit.cover,
                        errorBuilder: defaultImageErrorBuilder,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: theme.colorScheme.surfaceVariant,
                            child: Center(
                              child: SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: theme.colorScheme.surfaceVariant,
                        child: Icon(
                          Icons.play_circle_outline_rounded,
                          size: 8.w,
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
              ),
            ),
            // Gradient Overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
            ),
            // Badges
            _buildImageBadges(context, theme, hasDiscount),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBadges(
    BuildContext context,
    ThemeData theme,
    bool hasDiscount,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top badges
        Padding(
          padding: EdgeInsets.all(2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasDiscount) _buildDiscountBadge(theme, context),
              const Spacer(),
              _buildStatusBadge(context, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountBadge(ThemeData theme, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.error.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '${(((course.oldPrice - course.newPrice!) / course.oldPrice) * 100).round()}%',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onError,
          fontWeight: FontWeight.bold,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, ThemeData theme) {
    if (isEnrolled) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 3.w,
              color: theme.colorScheme.onPrimary,
            ),
          ],
        ),
      );
    } else if (isInCart) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.shopping_cart_rounded,
          size: 3.w,
          color: theme.colorScheme.onTertiary,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildContentSection(ThemeData theme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course Name - مختصر
        Text(
          course.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),

        // Course Description - مختصر أكتر
        Text(
          course.description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBottomSection(ThemeData theme, BuildContext context) {
    return Column(
      children: [
        // Course Stats - مدمجة في صف واحد
        Row(
          children: [
            _buildStatChip(
              icon: Icons.people_outline_rounded,
              label: '${course.subscribers}',
              color: theme.colorScheme.primary,
              theme: theme,
            ),
            SizedBox(width: 2.w),
            _buildStatChip(
              icon: Icons.play_lesson_outlined,
              label: '${course.lectures.length}',
              color: theme.colorScheme.secondary,
              theme: theme,
            ),
          ],
        ),
        SizedBox(height: 1.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCompactPriceSection(theme, context),
            if (!isEnrolled) _buildCompactActionButton(context, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 3.w, color: color),
          SizedBox(width: 1.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactPriceSection(ThemeData theme, BuildContext context) {
    final hasDiscount =
        course.newPrice != null && course.newPrice! < course.oldPrice;

    if (hasDiscount) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${course.oldPrice.toStringAsFixed(0)} ${S.of(context).currency}',
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10.sp,
            ),
          ),
          Text(
            '${course.newPrice!.toStringAsFixed(0)} ${S.of(context).currency}',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Text(
        '${course.oldPrice.toStringAsFixed(0)} ${S.of(context).currency}',
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget _buildCompactActionButton(BuildContext context, ThemeData theme) {
    if (isEnrolled) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onEnrollPressed,
          borderRadius: BorderRadius.circular(25),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                size: 4.w,
                color: theme.colorScheme.onPrimary,
              ),
              SizedBox(width: 1.w),
              Text(
                S.of(context).continueWatching,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (isInCart) {
      return GestureDetector(
        onTap: () {
          if (onAddToCartPressed != null) {
            onAddToCartPressed!();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.error, width: 1.5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.remove_shopping_cart_rounded,
                size: 4.w,
                color: theme.colorScheme.error,
              ),
              SizedBox(width: 1.w),
              Text(
                S.of(context).removeFromCart,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        // استخدم GestureDetector هنا أيضاً
        onTap: () {
          if (onAddToCartPressed != null) {
            onAddToCartPressed!();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.secondary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_shopping_cart_rounded,
                size: 4.w,
                color: theme.colorScheme.onSecondary,
              ),
              SizedBox(width: 1.w),
              Text(
                S.of(context).addToCart,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
