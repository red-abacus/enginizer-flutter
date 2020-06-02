import 'dart:convert';

import 'package:app/utils/environment.constants.dart';
import 'package:dio/dio.dart';

import '../../../config/injection.dart';

class NotificationService {
  Dio _dio = inject<Dio>();

  NotificationService();

  static const String REGISTER_NOTIFICATION_EXCEPTION =
      'REGISTER_NOTIFICATION_EXCEPTION';
  static const String UNREGISTER_NOTIFICATION_EXCEPTION =
      'UNREGISTER_NOTIFICATION_EXCEPTION';

  static const String _REGISTER_PATH =
      '${Environment.NOTIFICATIONS_BASE_API}/fcm/group/add';
  static const String _UNREGISTER_PATH =
      '${Environment.NOTIFICATIONS_BASE_API}/fcm/group/remove';

  Future<bool> register(String fcmToken) async {
    try {
      final response = await _dio.post(_REGISTER_PATH,
          data: jsonEncode(fcmToken));
      if (response.statusCode == 200) {
        print('FIREBASE: registered!');
        return true;
      } else {
        throw Exception(REGISTER_NOTIFICATION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(REGISTER_NOTIFICATION_EXCEPTION);
    }
  }

  Future<bool> unregister(String fcmToken) async {
    try {
      final response = await _dio.post(_UNREGISTER_PATH,
          data: jsonEncode(fcmToken));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(UNREGISTER_NOTIFICATION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(UNREGISTER_NOTIFICATION_EXCEPTION);
    }
  }
}
