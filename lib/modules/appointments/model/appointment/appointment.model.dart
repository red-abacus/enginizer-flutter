import 'package:app/modules/appointments/model/appointment/appointment-status.model.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/appointments/model/operating-unit.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/date_utils.dart';
import 'package:intl/intl.dart';

import '../../../cars/models/car.model.dart';
import '../operating-unit.model.dart';

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
  ServiceProvider serviceProvider;
  GenericModel buyer;
  GenericModel seller;

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
      this.serviceProvider,
      this.buyer,
      this.seller});

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
        name: json['name'] != null ? json['name'] : '',
        serviceProvider: json['provider'] != null
            ? ServiceProvider.fromJson(json["provider"])
            : null,
        buyer:
            json['buyer'] != null ? GenericModel.fromJson(json['buyer']) : null,
        seller: json['seller'] != null
            ? GenericModel.fromJson(json['seller'])
            : null);
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
        statusFilter = state == status.getState();
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
}
