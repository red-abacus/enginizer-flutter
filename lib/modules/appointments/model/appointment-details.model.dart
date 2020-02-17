import 'package:enginizer_flutter/modules/appointments/model/appointment-status.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/issue-item.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/operating-unit.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:intl/intl.dart';

import 'appointment-type.model.dart';

class AppointmentDetail {
  Car car;
  List<IssueItem> issues = [];
  List<ServiceItem> serviceItems = [];
  String scheduledDate;

  AppointmentDetail(
      {this.car, this.issues, this.serviceItems, this.scheduledDate});

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
        car: Car.fromJson(json["car"]),
        issues: _mapIssuesList(json["issues"]),
        serviceItems: _mapServiceItems(json["services"]),
        scheduledDate: json["scheduledDateTime"] != null ? json["scheduledDateTime"] : "");
  }

  static _mapIssuesList(List<dynamic> response) {
    List<IssueItem> appointmentTypes = [];
    response.forEach((item) {
      appointmentTypes.add(IssueItem.fromJson(item));
    });
    return appointmentTypes;
  }

  static _mapServiceItems(List<dynamic> response) {
    List<ServiceItem> services = [];
    response.forEach((item) {
      services.add(ServiceItem.fromJson(item));
    });
    return services;
  }
}
