import 'package:flutter/material.dart';
import 'package:math_corn/core/extentions/date_extention.dart';
import 'package:math_corn/core/extentions/string_direction_extention.dart';
import 'package:math_corn/modules/notifications/data/models/app_notifications.dart';
import 'package:sizer/sizer.dart';

class NotificationWidget extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onDismiss;

  const NotificationWidget({
    super.key,
    required this.notification,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrivate = notification.type == "private";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type indicator and dismiss button
              Row(
                children: [
                  // Type indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 0.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: isPrivate
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPrivate ? "خاص" : "عام",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isPrivate
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Date
                  Text(
                    notification.date.toDateString,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  // Dismiss button for private notifications only
                  if (isPrivate && onDismiss != null) ...[
                    SizedBox(width: 2.w),
                    InkWell(
                      onTap: onDismiss,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        child: Icon(
                          Icons.close,
                          size: 4.w,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 2.h),

              // Title
              Text(
                notification.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textDirection: notification.title.getDirection,
              ),
              SizedBox(height: 1.h),

              // Body
              Text(
                notification.body,
                style: theme.textTheme.bodyMedium,
                textDirection: notification.body.getDirection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final AppNotification notification;
  final VoidCallback? onDismiss;
  final bool showDismissAnimation;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onDismiss,
    this.showDismissAnimation = true,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() async {
    if (_isDismissed) return;

    setState(() {
      _isDismissed = true;
    });

    if (widget.showDismissAnimation) {
      await _animationController.forward();
    }

    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrivate = widget.notification.type == "private";

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(100.w * _slideAnimation.value, 0),
          child: Opacity(
            opacity: _fadeAnimation.value == 0.0 ? 1.0 : _fadeAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Dismissible(
                key: Key(widget.notification.id),
                direction: isPrivate
                    ? DismissDirection.endToStart
                    : DismissDirection.none,
                onDismissed: isPrivate ? (_) => _handleDismiss() : null,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 4.w),
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: theme.colorScheme.onError,
                        size: 6.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "إزالة",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onError,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surface.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          children: [
                            // Type Badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 0.8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isPrivate
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        (isPrivate
                                                ? theme.colorScheme.primary
                                                : theme.colorScheme.secondary)
                                            .withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                isPrivate ? "خاص" : "عام",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                            const Spacer(),

                            // Date with icon
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 3.5.w,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  widget.notification.date.toDateString,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),

                            // Manual dismiss button for private notifications
                            if (isPrivate && widget.onDismiss != null) ...[
                              SizedBox(width: 2.w),
                              GestureDetector(
                                onTap: () => _showDismissConfirmation(context),
                                child: Container(
                                  padding: EdgeInsets.all(1.5.w),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 4.w,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        SizedBox(height: 2.h),

                        // Title
                        Text(
                          widget.notification.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                            color: theme.colorScheme.onSurface,
                          ),
                          textDirection: widget.notification.title.getDirection,
                        ),

                        SizedBox(height: 1.h),

                        // Body
                        Text(
                          widget.notification.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.4,
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                          textDirection: widget.notification.body.getDirection,
                        ),

                        // Dismissible hint for private notifications
                        if (isPrivate && widget.onDismiss != null) ...[
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant
                                  .withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.outline.withOpacity(
                                  0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.swipe_left,
                                  size: 3.5.w,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    "اسحب يساراً لإزالة الإشعار",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDismissConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(width: 2.w),
            const Text("إزالة الإشعار"),
          ],
        ),
        content: const Text(
          "هل أنت متأكد من إزالة هذا الإشعار؟ لن تتمكن من استعادته مرة أخرى.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleDismiss();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text("إزالة"),
          ),
        ],
      ),
    );
  }
}
