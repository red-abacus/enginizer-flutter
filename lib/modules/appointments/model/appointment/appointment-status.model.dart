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
      case AppointmentStatusState.NEW:
        return gray;
      case AppointmentStatusState.CANCELED:
      case AppointmentStatusState.OPEN_BID:
        return red;
      case AppointmentStatusState.DONE:
      case AppointmentStatusState.ACCEPTED:
      case AppointmentStatusState.IN_TRANSPORT:
      case AppointmentStatusState.READY_FOR_PICKUP:
        return green;
      case AppointmentStatusState.NONE:
        return gray2;
      default:
        return yellow;
    }
  }

  String assetName() {
    String prefix = 'assets/images/statuses/';
    String suffix = '.svg';
    switch (getState()) {
      case AppointmentStatusState.NEW:
      case AppointmentStatusState.ACCEPTED:
        return prefix + 'completed' + suffix;
      default:
        return prefix + name.toLowerCase() + suffix;
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
      case 'READY_FOR_PICKUP':
        return AppointmentStatusState.READY_FOR_PICKUP;
      default:
        return AppointmentStatusState.NONE;
    }
  }
}
