import 'package:enginizer_flutter/modules/appointments/model/appointment-issue.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/user.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';

class AppointmentDetail {
  Car car;
  List<AppointmentIssue> issues = [];
  List<ServiceItem> serviceItems = [];
  String scheduledDate;
  User user;

  AppointmentDetail(
      {this.car,
      this.issues,
      this.serviceItems,
      this.scheduledDate,
      this.user});

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
        car: Car.fromJson(json["car"]),
        issues: json["issues"] != null ? _mapIssuesList(json["issues"]) : [],
        serviceItems:
            json["services"] != null ? _mapServiceItems(json["services"]) : [],
        scheduledDate: json["scheduledDateTime"],
        user: User.fromJson(json["user"]));
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

  List<Issue> getIssues() {
    List<Issue> list = [];

    for(AppointmentIssue issue in this.issues) {
      list.add(Issue.fromAppointmentIssue(issue));
    }

    return list;
  }
}
