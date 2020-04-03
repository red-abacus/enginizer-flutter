import 'dart:async';

import 'package:app/database/database.dart';
import 'package:app/database/models/notification.model.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseManager {
  static final FirebaseManager _singleton = FirebaseManager._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  factory FirebaseManager() {
    return _singleton;
  }

  FirebaseManager._internal();

  static getInstance() {
    return _singleton;
  }

  Future<void> initialise() async {
    NotificationsManager.checkNotificationsCount();

    _firebaseMessaging.subscribeToTopic('general');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        AppNotification notification = AppNotification.fromNotification(message);

        if (notification != null) {
          Database.getInstance()
              .addNotification(notification);
          NotificationsManager.showNotificationBanner(notification);
        }
      },
      onBackgroundMessage: FirebaseManager.firebaseBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        AppNotification notification = AppNotification.fromNotification(message);

        if (notification != null) {
          Database.getInstance()
              .addNotification(notification);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        AppNotification notification = AppNotification.fromNotification(message);

        if (notification != null) {
          Database.getInstance()
              .addNotification(notification);
        }
      },
    );
  }

  static Future<dynamic> firebaseBackgroundMessageHandler(
      Map<String, dynamic> message) {
    AppNotification notification = AppNotification.fromNotification(message);

    if (notification != null) {
      Database.getInstance()
          .addNotification(notification);
    }
    return Future<void>.value();
  }
}
