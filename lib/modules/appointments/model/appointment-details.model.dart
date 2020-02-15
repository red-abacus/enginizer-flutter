import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';

class AppointmentDetail {
  Car car;
  List<AppointmentIssue> issues = [];
  List<ServiceItem> serviceItems = [];
  String scheduledDate;

  AppointmentDetail(
      {this.car, this.issues, this.serviceItems, this.scheduledDate});

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
        car: Car.fromJson(json["car"]),
        issues: _mapIssuesList(json["issues"]),
        serviceItems: _mapServiceItems(json["services"]),
        scheduledDate: json["scheduleDateTime"]);
  }

  static _mapIssuesList(List<dynamic> response) {
    List<AppointmentIssue> appointmentTypes = [];
    response.forEach((item) {
      appointmentTypes.add(AppointmentIssue.fromJson(item));
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
