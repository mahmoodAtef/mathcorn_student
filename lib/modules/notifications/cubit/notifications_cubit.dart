import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:math_corn/modules/notifications/data/models/app_notifications.dart';
import 'package:math_corn/modules/notifications/data/repositories/notification_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _repository;

  NotificationsCubit(this._repository) : super(NotificationsState());

  Future<void> getNotifications({required String grade}) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final notifications = await _repository.getNotifications(grade);
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          notifications: notifications,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: NotificationsStatus.failure, exception: e));
    }
  }

  Future<void> markNotificationAsRead({required String id}) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      await _repository.markNotificationAsRead(notificationId: id);
      emit(state.copyWith(status: NotificationsStatus.success));
    } on Exception catch (e) {
      emit(state.copyWith(status: NotificationsStatus.failure, exception: e));
    }
  }

  Future<void> getMessageOfTheDay() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    try {
      final messageOfTheDay = await _repository.getMessageOfTheDay();
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          messageOfTheDay: messageOfTheDay,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: NotificationsStatus.failure, exception: e));
    }
  }
}
