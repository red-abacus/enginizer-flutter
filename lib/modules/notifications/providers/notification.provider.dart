import 'package:app/config/injection.dart';
import 'package:app/modules/notifications/models/app-notification-response.model.dart';
import 'package:app/modules/notifications/models/app-notification.model.dart';
import 'package:app/modules/notifications/services/notification.service.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider with ChangeNotifier {
  NotificationService _notificationService = inject<NotificationService>();

  List<AppNotification> notifications = [];

  AppNotificationResponse notificationResponse;

  int _notificationsPage = 0;
  int _pageSize = 20;

  initialiseParams() {
    _notificationsPage = 0;
    notificationResponse = null;
    notifications = [];
  }

  Future<AppNotificationResponse> loadNotifications() async {
    if (notificationResponse != null) {
      if (_notificationsPage >= notificationResponse.totalPages) {
        return null;
      }
    }

    try {
      notificationResponse = await _notificationService.getNotifications(_notificationsPage,
          pageSize: _pageSize);
      this.notifications.addAll(notificationResponse.notifications);
      _notificationsPage += 1;
      return notificationResponse;
    } catch (error) {
      throw (error);
    }
  }
}
