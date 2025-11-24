part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  final List<AppNotification>? notifications;
  final NotificationsStatus status;
  final Exception? exception;
  final String? messageOfTheDay;

  const NotificationsState({
    this.notifications = const [],
    this.status = NotificationsStatus.initial,
    this.exception,
    this.messageOfTheDay,
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    NotificationsStatus? status,
    Exception? exception,
    String? messageOfTheDay,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      status: status ?? this.status,
      exception: exception ?? this.exception,
      messageOfTheDay: messageOfTheDay ?? this.messageOfTheDay,
    );
  }

  @override
  List<Object?> get props => [notifications, status, exception];
}
