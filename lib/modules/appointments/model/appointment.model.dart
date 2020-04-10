import 'package:app/modules/appointments/model/appointment-details.model.dart';
import 'package:app/modules/appointments/model/appointment-status.model.dart';
import 'package:app/modules/appointments/model/operating-unit.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../cars/models/car.model.dart';
import 'appointment-type.model.dart';
import 'operating-unit.model.dart';

class Appointment {
  int id;
  String name;

  DateTime date;
  String createdDate;
  String scheduleDateTime;

  Car car;
  String appointmentType;
  OperatingUnit operatingUnit;
  AppointmentStatus status;
  AppointmentDetail appointmentDetail;
  ServiceProvider serviceProvider;

  Appointment(
      {this.id,
      this.date,
      this.createdDate,
      this.scheduleDateTime,
      this.car,
      this.appointmentType,
      this.operatingUnit,
      this.status,
      this.name,
      this.serviceProvider});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'],
        date: json['date'] != null
            ? DateFormat('dd/MM/yyyy').parse(json['itpExpireDate'])
            : null,
        createdDate: json['createdDate'] != null ? json["createdDate"] : null,
        scheduleDateTime:
            json['scheduledDateTime'] != null ? json['scheduledDateTime'] : "",
        car: json['car'] != null ? Car.fromJson(json['car']) : null,
        appointmentType: json['appointmentType'],
        operatingUnit: json['operatingUnit'] != null
            ? OperatingUnit.fromJson(json['operatingUnit'])
            : null,
        status: json['status'] != null
            ? AppointmentStatus.fromJson(json['status'])
            : null,
        name: json["name"] != null ? json["name"] : "",
        serviceProvider: json['provider'] != null
            ? ServiceProvider.fromJson(json["provider"])
            : null);
  }

  static _mapAppointmentTypes(List<dynamic> response) {
    List<AppointmentType> appointmentTypes = [];
    response.forEach((item) {
      appointmentTypes.add(AppointmentType.fromJson(item));
    });
    return appointmentTypes;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'date': date.toIso8601String(),
      'createdDate': createdDate,
      'scheduleDateTime': scheduleDateTime,
      'car': car.toJson(),
      'appointmentTypes': appointmentType,
      'operatingUnit': operatingUnit.toJson(),
      'status': status.toJson()
    };

    if (id != null) {
      propMap.putIfAbsent('id', () => id);
    }

    return propMap;
  }

  static String scheduledTimeFormat() {
    return "dd/MM/yyyy HH:mm";
  }

  bool filtered(String value, AppointmentStatusState state, DateTime dateTime) {
    var textFilter = false;

    if (value.isEmpty) {
      textFilter = true;
    } else {
      if (car != null) {
        if (car.brand != null) {
          if (car.brand.name != null) {
            textFilter =
                car.brand.name.toLowerCase().contains(value.toLowerCase());
          }
        }

        if (car.registrationNumber != null) {
          textFilter = textFilter ||
              car.registrationNumber
                  .toLowerCase()
                  .contains(value.toLowerCase());
        }
      }
    }

    var statusFilter = false;

    if (state == null) {
      statusFilter = true;
    } else {
      if (state == AppointmentStatusState.NONE) {
        statusFilter = true;
      } else {
        statusFilter = state == getState();
      }
    }

    bool timeFilter = false;

    if (dateTime == null) {
      timeFilter = true;
    } else {
      if (scheduleDateTime != null) {
        DateTime scheduledDateTime = DateUtils.dateFromString(
            this.scheduleDateTime, scheduledTimeFormat());

        if (scheduledDateTime != null) {
          timeFilter = DateUtils.isSameDay(dateTime, scheduledDateTime);
        }
      }
    }

    return textFilter && statusFilter && timeFilter;
  }

  Color resolveStatusColor() {
    switch (getState()) {
      case AppointmentStatusState.SUBMITTED:
        return gray;
      case AppointmentStatusState.IN_WORK:
        return yellow;
      case AppointmentStatusState.CANCELED:
        return red;
      case AppointmentStatusState.DONE:
        return green;
      default:
    }

    return gray2;
  }

  String assetName() {
    switch (getState()) {
      case AppointmentStatusState.IN_WORK:
        return 'in_work';
      case AppointmentStatusState.OPEN_BID:
        return 'in_bid';
      case AppointmentStatusState.PENDING:
        return 'waiting';
      case AppointmentStatusState.DONE:
        return 'completed';
      default:
        return status.name.toLowerCase();
    }
  }

  AppointmentStatusState getState() {
    switch (status.name.toLowerCase()) {
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
      default:
        return AppointmentStatusState.NONE;
    }
  }
}
