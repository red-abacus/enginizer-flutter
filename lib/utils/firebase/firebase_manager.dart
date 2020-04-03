import 'dart:async';

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
    _firebaseMessaging.subscribeToTopic('general');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: FirebaseManager.firebaseBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  static Future<dynamic> firebaseBackgroundMessageHandler(Map<String, dynamic> message) {
    print('message $message');
  }
}