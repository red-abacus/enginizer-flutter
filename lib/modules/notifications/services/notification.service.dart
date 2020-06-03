import 'dart:convert';

import 'package:app/modules/notifications/models/app-notification-response.model.dart';
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
  static const String GET_NOTIFICATIONS_EXCEPTION =
      'GET_NOTIFICATIONS_EXCEPTION';
  static const String MARK_AS_SEEN_EXCEPTION = 'GET_NOTIFICATIONS_EXCEPTION';

  static const String _REGISTER_PATH =
      '${Environment.NOTIFICATIONS_BASE_API}/fcm/group/add';
  static const String _UNREGISTER_PATH =
      '${Environment.NOTIFICATIONS_BASE_API}/fcm/group/remove';
  static const String _GET_NOTIFICATIONS_PATH =
      '${Environment.NOTIFICATIONS_BASE_API}/notification';
  static const String _MARK_AS_SEEN_PATH = '${Environment.NOTIFICATIONS_BASE_API}/notification/markSeen';

  Future<bool> register(String fcmToken) async {
    try {
      final response =
          await _dio.post(_REGISTER_PATH, data: fcmToken);
      if (response.statusCode == 200) {
        print('[FIREBASE] Registered');
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
      final response =
          await _dio.post(_UNREGISTER_PATH, data: jsonEncode(fcmToken));
      if (response.statusCode == 200) {
        print('[FIREBASE] Unregister');
        return true;
      } else {
        throw Exception(UNREGISTER_NOTIFICATION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(UNREGISTER_NOTIFICATION_EXCEPTION);
    }
  }

  Future<AppNotificationResponse> getNotifications(int page,
      {int pageSize}) async {
    Map<String, dynamic> queryParameters = {'page': '$page'};

    if (pageSize != null) {
      queryParameters['pageSize'] = '$pageSize';
    }

    try {
      final response = await _dio.get(_GET_NOTIFICATIONS_PATH,
          queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return AppNotificationResponse.fromJson(response.data);
      } else {
        throw Exception(UNREGISTER_NOTIFICATION_EXCEPTION);
      }
    } catch (error) {
      throw Exception(UNREGISTER_NOTIFICATION_EXCEPTION);
    }
  }

  Future<bool> markAsSeen(List<String> ids) async {
    try {
      final response = await _dio.patch(_MARK_AS_SEEN_PATH, data: jsonEncode(ids));
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(MARK_AS_SEEN_EXCEPTION);
      }
    } catch (error) {
      throw Exception(MARK_AS_SEEN_EXCEPTION);
    }
  }
}
