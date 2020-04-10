import 'dart:collection';

class AppNotification {
  String title;
  String body;
  bool read;

  AppNotification({this.title, this.body, this.read});

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
        title: json['title'] != null ? json['title'] : '',
        body: json['body'] != null ? json['body'] : '',
        read: json['read'] != null ? json['read'] : false);
  }

  static AppNotification fromNotification(Map<String, dynamic> json) {
    Map notificationMap = json['notification'];

    if (notificationMap != null) {
      return AppNotification(
          title:
          notificationMap['title'] != null ? notificationMap['title'] : '',
          body: notificationMap['body'] != null ? notificationMap['body'] : '',
          read: false);
    }
    else {
      notificationMap = json['data'];

      if (notificationMap != null) {
        return AppNotification(
            title:
            notificationMap['title'] != null ? notificationMap['title'] : '',
            body: notificationMap['body'] != null ? notificationMap['body'] : '',
            read: false);
      }
    }

    return null;
  }

  HashMap<String, dynamic> getJson() {
    HashMap<String, dynamic> json = new HashMap();
    json['title'] = title;
    json['body'] = body;
    json['read'] = read;
    return json;
  }
}
