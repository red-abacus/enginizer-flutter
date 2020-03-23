import 'package:enginizer_flutter/modules/appointments/model/service-item.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/issue.model.dart';
import 'package:enginizer_flutter/modules/authentication/models/user.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';

class AppointmentDetail {
  Car car;
  List<Issue> issues = [];
  List<ServiceItem> serviceItems = [];
  String scheduledDate;
  User user;
  int workEstimateId;

  AppointmentDetail(
      {this.car,
      this.issues,
      this.serviceItems,
      this.scheduledDate,
      this.user,
      this.workEstimateId});

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
        car: Car.fromJson(json["car"]),
        issues: json["issues"] != null ? _mapIssuesList(json["issues"]) : [],
        serviceItems:
            json["services"] != null ? _mapServiceItems(json["services"]) : [],
        scheduledDate: json["scheduledDateTime"],
        user: User.fromJson(json["user"]),
        workEstimateId: json['workEstimateId']);
  }

  static _mapIssuesList(List<dynamic> response) {
    List<Issue> list = [];
    response.forEach((item) {
      list.add(Issue.fromJson(item));
    });
    return list;
  }

  static _mapServiceItems(List<dynamic> response) {
    List<ServiceItem> services = [];
    response.forEach((item) {
      services.add(ServiceItem.fromJson(item));
    });
    return services;
  }

  bool hasWorkEstimate() {
    if (workEstimateId != null && workEstimateId > 0) {
      return true;
    }

    return false;
  }
}
