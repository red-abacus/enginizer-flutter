import 'dart:ui';

import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/utils/constants.dart';

class AppointmentStatus {
  int id;
  String name;

  AppointmentStatus(status) {
    if (status is String) {
      this.name = status;
    } else {
      this.id = status.id;
      this.name = status.name;
    }
  }

  factory AppointmentStatus.fromJson(dynamic json) {
    return AppointmentStatus(json);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {'name': name};

    if (id != null) {
      propMap.putIfAbsent('id', () => id);
    }

    return propMap;
  }

  Color resolveStatusColor() {
    switch (getState()) {
      case AppointmentStatusState.SUBMITTED:
      case AppointmentStatusState.IN_REVIEW:
      case AppointmentStatusState.NEW:
        return gray;
      case AppointmentStatusState.CANCELED:
        return red;
      case AppointmentStatusState.DONE:
        return green;
      case AppointmentStatusState.NONE:
        return gray2;
      default:
        return yellow;
    }
  }

  String assetName() {
    // TODO - need to check again these assets
    switch (getState()) {
      case AppointmentStatusState.IN_WORK:
        return 'in_work';
      case AppointmentStatusState.IN_REVIEW:
        return 'waiting';
      case AppointmentStatusState.OPEN_BID:
        return 'in_bid';
      case AppointmentStatusState.PENDING:
        return 'waiting';
      case AppointmentStatusState.DONE:
      case AppointmentStatusState.NEW:
        return 'completed';
      default:
        return name.toLowerCase();
    }
  }

  AppointmentStatusState getState() {
    switch (name.toLowerCase()) {
      case 'inreview':
        return AppointmentStatusState.IN_REVIEW;
      case 'inwork':
        return AppointmentStatusState.IN_WORK;
      case 'pending':
        return AppointmentStatusState.PENDING;
      case 'submitted':
        return AppointmentStatusState.SUBMITTED;
      case 'scheduled':
        return AppointmentStatusState.SCHEDULED;
      case 'canceled':
        return AppointmentStatusState.CANCELED;
      case 'openbid':
        return AppointmentStatusState.OPEN_BID;
      case 'done':
        return AppointmentStatusState.DONE;
      case 'onhold':
        return AppointmentStatusState.ON_HOLD;
      case 'inunit':
        return AppointmentStatusState.IN_UNIT;
      case 'new':
        return AppointmentStatusState.NEW;
      default:
        return AppointmentStatusState.NONE;
    }
  }
}
