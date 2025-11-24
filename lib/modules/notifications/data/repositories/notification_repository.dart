import 'package:math_corn/modules/notifications/data/models/app_notifications.dart';
import 'package:math_corn/modules/notifications/data/services/notification_services.dart';

class NotificationRepository {
  final NotificationServices _notificationServices;

  const NotificationRepository(this._notificationServices);

  Future<void> markNotificationAsRead({required String notificationId}) async {
    await _notificationServices.markNotificationAsRead(
      notificationId: notificationId,
    );
  }

  Future<String> getMessageOfTheDay() async {
    return _notificationServices.getMessageOfTheDay();
  }

  Future<List<AppNotification>> getNotifications(String grade) async {
    return _notificationServices.getNotifications(grade: grade);
  }
}
