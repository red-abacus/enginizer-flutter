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
      case AppointmentStatusState.OPEN_BID:
        return red;
      case AppointmentStatusState.DONE:
      case AppointmentStatusState.ACCEPTED:
      case AppointmentStatusState.IN_TRANSPORT:
        return green;
      case AppointmentStatusState.NONE:
        return gray2;
      default:
        return yellow;
    }
  }

  String assetName() {
    switch (getState()) {
      case AppointmentStatusState.ON_HOLD:
        return 'pending';
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
      case AppointmentStatusState.ACCEPTED:
        return 'completed';
      default:
        return name.toLowerCase();
    }
  }

  AppointmentStatusState getState() {
    switch (name) {
      case 'IN_REVIEW':
        return AppointmentStatusState.IN_REVIEW;
      case 'IN_WORK':
        return AppointmentStatusState.IN_WORK;
      case 'PENDING':
        return AppointmentStatusState.PENDING;
      case 'SUBMITTED':
        return AppointmentStatusState.SUBMITTED;
      case 'SCHEDULED':
        return AppointmentStatusState.SCHEDULED;
      case 'CANCELED':
        return AppointmentStatusState.CANCELED;
      case 'OPEN_BID':
        return AppointmentStatusState.OPEN_BID;
      case 'DONE':
        return AppointmentStatusState.DONE;
      case 'ON_HOLD':
        return AppointmentStatusState.ON_HOLD;
      case 'IN_UNIT':
        return AppointmentStatusState.IN_UNIT;
      case 'NEW':
        return AppointmentStatusState.NEW;
      case 'ACCEPTED':
        return AppointmentStatusState.ACCEPTED;
      case 'IN_TRANSPORT':
        return AppointmentStatusState.IN_TRANSPORT;
      default:
        return AppointmentStatusState.NONE;
    }
  }
}
