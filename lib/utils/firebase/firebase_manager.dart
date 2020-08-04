import 'dart:async';

import 'package:app/modules/authentication/providers/auth.provider.dart';
import 'package:app/modules/shared/widgets/notifications-manager.dart';
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
    _firebaseMessaging.getToken().then((token) {
      fcmToken = token;

      if (_context != null) {
        Provider.of<Auth>(_context).register(fcmToken);
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        parseNotification(message);
      },
      onBackgroundMessage: FirebaseManager.firebaseBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        parseNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        parseNotification(message);
      },
    );
  }

  static Future<dynamic> firebaseBackgroundMessageHandler(
      Map<String, dynamic> message) {
//    AppNotification notification = AppNotification.fromNotification(message);
//
//    if (notification != null) {
//      Database.getInstance()
//          .addNotification(notification);
//    }
    return Future<void>.value();
  }

  parseNotification(Map<String, dynamic> message) {
    if (message['notification'] != null) {
      var notificationData = message['notification'];

      String title = notificationData['title'] != null ? notificationData['title'] : '';
      String body = notificationData['body'] != null ? notificationData['body'] : '';

      NotificationsManager.showNotificationBanner(title, body);
    }
  }
}
