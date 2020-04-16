import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/authentication/models/user.model.dart';
import 'package:app/modules/cars/models/car.model.dart';

class AppointmentDetail {
  Car car;
  List<Issue> issues = [];
  List<ServiceItem> serviceItems = [];
  String scheduledDate;
  User user;
  int workEstimateId;
  ServiceProvider serviceProvider;

  AppointmentDetail(
      {this.car,
      this.issues,
      this.serviceItems,
      this.scheduledDate,
      this.user,
      this.workEstimateId,
      this.serviceProvider});

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    return AppointmentDetail(
        car: Car.fromJson(json["car"]),
        issues: json["issues"] != null ? _mapIssuesList(json["issues"]) : [],
        serviceItems:
            json["services"] != null ? _mapServiceItems(json["services"]) : [],
        scheduledDate: json["scheduledDateTime"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        workEstimateId: json['workEstimateId'],
        serviceProvider: json['provider'] != null ? ServiceProvider.fromJson(json['provider']) : null);
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
