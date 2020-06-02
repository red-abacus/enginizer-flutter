import 'app-notification.model.dart';

class AppNotificationResponse {
  int total;
  int totalPages;
  List<AppNotification> notifications;

  AppNotificationResponse({this.total, this.totalPages, this.notifications});

  factory AppNotificationResponse.fromJson(Map<String, dynamic> json) {
    return AppNotificationResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        notifications: _mapNotifications(json['items']));
  }

  static _mapNotifications(List<dynamic> response) {
    List<AppNotification> appointmentsList = [];
    response.forEach((item) {
      appointmentsList.add(AppNotification.fromJson(item));
    });
    return appointmentsList;
  }
}