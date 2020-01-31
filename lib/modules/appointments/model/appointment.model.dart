import 'package:enginizer_flutter/modules/appointments/model/appointment-status.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/operating-unit.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:intl/intl.dart';

import 'appointment-type.model.dart';

class Appointment {
  int id;

  DateTime date;
  String createdDate;
  String scheduleDateTime;

  Car car;
  List<AppointmentType> appointmentTypes;
  OperatingUnit operatingUnit;
  AppointmentStatus status;

  Appointment(
      {this.id,
      this.date,
      this.createdDate,
      this.scheduleDateTime,
      this.car,
      this.appointmentTypes,
      this.operatingUnit,
      this.status});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json['id'],
        date: json['date'] != null
            ? DateFormat('dd/MM/yyyy').parse(json['itpExpireDate'])
            : null,
        createdDate: json['createdDate'],
        scheduleDateTime: json['scheduleDateTime'],
        car: json['car'] != null ? Car.fromJson(json['car']) : null,
        appointmentTypes: json['appointmentType'] != null
            ? _mapAppointmentTypes(json['appointmentType'])
            : null,
        operatingUnit: json['operatingUnit'] != null
            ? OperatingUnit.fromJson(json['operatingUnit'])
            : null,
        status: json['status'] != null
            ? AppointmentStatus.fromJson(json['status'])
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
      'appointmentTypes':
          appointmentTypes.map((appointmentType) => appointmentType.toJson()),
      'operatingUnit': operatingUnit.toJson(),
      'status': status.toJson()
    };

    if (id != null) {
      propMap.putIfAbsent('id', () => id);
    }

    return propMap;
  }
}
