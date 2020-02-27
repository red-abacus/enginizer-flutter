import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-details.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/appointment-status.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/operating-unit.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/auctions/enum/appointment-status.enum.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/utils/constants.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
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
    print('json ${json['status']}');
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
      statusFilter = false;
    }

    if (state == AppointmentStatusState.ALL) {
      statusFilter = true;
    } else {
      statusFilter = state == getState();
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
    if (status != null) {
      switch (status.name.toLowerCase()) {
        case 'completed':
          return green;
        case 'in_work':
          return yellow;
        case 'submitted':
          return gray;
        case 'canceled':
          return red;
      }
    }

    return gray;
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
      default:
        return AppointmentStatusState.ALL;
    }
  }

  static String _titleState(BuildContext context, AppointmentStatusState state) {
    switch (state) {
      case AppointmentStatusState.IN_WORK:
        return S.of(context).appointment_status_in_work;
      case AppointmentStatusState.PENDING:
        return S.of(context).appointment_status_pending;
      case AppointmentStatusState.SUBMITTED:
        return S.of(context).appointment_status_submitted;
      case AppointmentStatusState.SCHEDULED:
        return S.of(context).appointment_status_scheduled;
      case AppointmentStatusState.ALL:
        return S.of(context).general_all;
    }
  }

  static String getTitleForState(
      BuildContext buildContext, AppointmentStatusState state) {
    return _titleState(buildContext, state);
  }

  String getAppointmentStateTitle(BuildContext buildContext) {
    return _titleState(buildContext, getState());
  }
}
