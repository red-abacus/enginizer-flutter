import 'dart:convert';

import 'package:app/database/models/notification.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {
  final String _notificationsKey = 'notifications_key';

  static final Database _singleton = Database._internal();

  factory Database() {
    return _singleton;
  }

  Database._internal();

  static Database getInstance() {
    return _singleton;
  }

  Future<List<AppNotification>> getNotifications() async {
    List<AppNotification> notifications = [];

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey(_notificationsKey)) {
      String notificationString = _prefs.getString(_notificationsKey);

      if (notificationString.isNotEmpty) {
        List<dynamic> array = jsonDecode(notificationString);

        if (array != null) {
          array.forEach((element) {
            if (element != null && element is Map) {
              notifications.add(AppNotification.fromJson(element));
            }
          });
        }
      }
    }

    return notifications;
  }

  void addNotification(AppNotification notification) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (_prefs.containsKey(_notificationsKey)) {
      String notificationString = _prefs.getString(_notificationsKey);

      if (notificationString.isNotEmpty) {
        List<dynamic> array = jsonDecode(notificationString);
        array.add(notification.getJson());
        _prefs.setString(_notificationsKey, jsonEncode(array));
      }
    }
    else {
      List<dynamic> array = new List();
      array.add(notification.getJson());
      _prefs.setString(_notificationsKey, jsonEncode(array));
    }
  }

  void markNotificationsAsRead() {
    getNotifications().then((notifications) async {
      List<dynamic> array = new List();
      for(AppNotification notification in notifications) {
        notification.read = true;
        array.add(notification.getJson());
      }

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _prefs.setString(_notificationsKey, jsonEncode(array));
    });
  }

  Future<int> getNotificationUnreadCount() async {
    List<AppNotification> notifications = await getNotifications();

    int count = 0;
    for(AppNotification notification in notifications) {
      if (!notification.read) {
        count += 1;
      }
    }
    return count;
  }
}
