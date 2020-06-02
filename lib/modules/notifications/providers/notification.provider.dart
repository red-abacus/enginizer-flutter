import 'package:app/config/injection.dart';
import 'package:app/modules/notifications/services/notification.service.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  NotificationService _notificationService = inject<NotificationService>();

}
