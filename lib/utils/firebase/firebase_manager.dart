import 'dart:async';

import 'package:app/database/database.dart';
import 'package:app/database/models/notification.model.dart';
import 'package:app/generated/l10n.dart';
import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/notifications/providers/notification.provider.dart';
import 'package:app/modules/notifications/services/notification.service.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
import 'package:app/utils/flush_bar.helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FirebaseManager {
  static final FirebaseManager _singleton = FirebaseManager._internal();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String fcmToken = '';
  BuildContext _context;

  factory FirebaseManager() {
    return _singleton;
  }

  FirebaseManager._internal();

  static getInstance() {
    return _singleton;
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  Future<void> initialise() async {
    NotificationsManager.checkNotificationsCount();

    _firebaseMessaging.getToken().then((token) {
      fcmToken = token;

      if (_context != null) {
        Provider.of<Auth>(_context).register(fcmToken);
      }
    });

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
