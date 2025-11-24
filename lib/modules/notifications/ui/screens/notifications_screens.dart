import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/widgets/core_widgets.dart';
import 'package:math_corn/generated/l10n.dart';
import 'package:math_corn/modules/notifications/cubit/notifications_cubit.dart';
import 'package:math_corn/modules/notifications/data/models/app_notifications.dart';
import 'package:math_corn/modules/notifications/ui/widgets/notification_card.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:sizer/sizer.dart';

enum NotificationFilter { all, public, private }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  NotificationFilter _currentFilter = NotificationFilter.all;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  late NotificationsCubit _notificationsCubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentFilter = NotificationFilter.values[_tabController.index];
      });
    });
    _notificationsCubit = sl<NotificationsCubit>();
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    final gradeId = context.read<StudentCubit>().state.student?.gradeId;
    if (gradeId != null) {
      _notificationsCubit.getNotifications(grade: gradeId);
    }
  }

  Future<void> _onRefresh() async {
    _loadNotifications();
  }

  void _dismissNotification(String notificationId) {
    context.read<NotificationsCubit>().markNotificationAsRead(
      id: notificationId,
    );

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).notificationDismissed),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<AppNotification> _getFilteredNotifications(
    List<AppNotification> notifications,
  ) {
    switch (_currentFilter) {
      case NotificationFilter.public:
        return notifications.where((n) => n.type == "public").toList();
      case NotificationFilter.private:
        return notifications.where((n) => n.type == "private").toList();
      default:
        return notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S l10n = S.of(context);
    return BlocProvider(
      create: (context) => _notificationsCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.notifications),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.onSurface,
            unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.4),
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.all_inclusive), text: l10n.all),
              Tab(icon: Icon(Icons.public), text: l10n.public),
              Tab(icon: Icon(Icons.person), text: l10n.private),
            ],
          ),
        ),
        body: BlocConsumer<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state.status == NotificationsStatus.failure &&
                state.exception != null) {
              showErrorDialog(context, state.exception!);
            }
          },
          builder: (context, state) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(state, NotificationFilter.all, context),
                _buildNotificationsList(
                  state,
                  NotificationFilter.public,
                  context,
                ),
                _buildNotificationsList(
                  state,
                  NotificationFilter.private,
                  context,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    NotificationsState state,
    NotificationFilter filter,
    BuildContext context,
  ) {
    switch (state.status) {
      case NotificationsStatus.loading:
        return const CustomLoadingWidget();

      case NotificationsStatus.failure:
        return Center(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomErrorWidget(
                  exception: state.exception ?? Exception("حدث خطأ غير متوقع"),
                  height: 30.h,
                ),
                SizedBox(height: 4.h),
                ElevatedButton.icon(
                  onPressed: _loadNotifications,
                  icon: const Icon(Icons.refresh),
                  label: Text(S.of(context).retry),
                ),
              ],
            ),
          ),
        );

      case NotificationsStatus.success:
        final allNotifications = state.notifications ?? [];
        final filteredNotifications = filter == NotificationFilter.all
            ? allNotifications
            : allNotifications
                  .where(
                    (n) => filter == NotificationFilter.public
                        ? n.type == "public"
                        : n.type == "private",
                  )
                  .toList();

        if (filteredNotifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [NoDataWidget(height: 25.h)],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 2.h),
            itemCount: filteredNotifications.length,
            itemBuilder: (context, index) {
              final notification = filteredNotifications[index];
              return NotificationWidget(
                notification: notification,
                onDismiss: notification.type == "private"
                    ? () => _dismissNotification(notification.id)
                    : null,
              );
            },
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
