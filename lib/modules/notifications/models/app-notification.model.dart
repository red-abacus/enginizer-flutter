import 'package:app/generated/l10n.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

class AppNotification {
  String id;
  DateTime date;
  bool seen;
  int userId;
  String eventType;
  int payloadId;
  String notificationType;

  AppNotification(
      {this.id,
      this.date,
      this.seen,
      this.userId,
      this.eventType,
      this.payloadId,
      this.notificationType});

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] != null ? json['id'] : '',
      date: json['timestamp'] != null
          ? DateUtils.dateFromTimestamp(json['timestamp'])
          : null,
      seen: json['seen'] != null ? json['seen'] : true,
      userId:
          json['generatedByUserId'] != null ? json['generatedByUserId'] : '',
      eventType: json['eventType'] != null ? json['eventType'] : '',
      payloadId: json['payload'] != null ? json['payload'] : 0,
      notificationType:
          json['notificationType'] != null ? json['notificationType'] : '',
    );
  }

  translateNotificationType(BuildContext context) {
    switch (notificationType) {
      case 'APPOINTMENT_CREATED':
        return S.of(context).notification_type_appointment_created;
        break;
      case 'APPOINTMENT_CANCELED':
        return S.of(context).notification_type_appointment_canceled;
        break;
      case 'APPOINTMENT_SCHEDULED':
        return S.of(context).notification_type_appointment_scheduled;
        break;
      case 'APPOINTMENT_FINISHED':
        return S.of(context).notification_type_appointment_finished;
        break;
      case 'APPOINTMENT_RECOMMENDATION_CREATED':
        return S
            .of(context)
            .notification_type_appointment_recommendation_created;
        break;
      case 'BID_CREATED':
        return S.of(context).notification_type_bid_created;
        break;
      case 'BID_ACCEPTED':
        return S.of(context).notification_type_bid_accepted;
        break;
      case 'BID_REJECTED':
        return S.of(context).notification_type_bid_rejected;
        break;
      default:
        return '';
    }
  }
}
