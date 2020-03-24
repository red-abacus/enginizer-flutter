import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/work-estimate-form/models/work-estimate-request.model.dart';

import '../../work-estimate-form/models/issue.model.dart';

class WorkEstimateDetails {
  int id;
  Appointment appointment;
  Car car;
  String createdDate;
  List<Issue> issues;
  ServiceProvider serviceProvider;
  String status;

  WorkEstimateDetails(
      {this.id,
      this.appointment,
      this.car,
      this.createdDate,
      this.issues,
      this.serviceProvider,
      this.status});

  factory WorkEstimateDetails.fromJson(Map<String, dynamic> json) {
    print('work estimate details $json');
    return WorkEstimateDetails(
        id: json['id'],
        appointment: json['appointment'] != null
            ? Appointment.fromJson(json['appointment'])
            : null,
        car: json['car'] != null ? Car.fromJson(json['car']) : null,
        createdDate: json['createdDate'],
        issues: json['issues'] != null ? _mapIssues(json['issues']) : [],
        serviceProvider: json['providerDto'] != null
            ? ServiceProvider.fromJson(json['providerDto'])
            : null,
        status: json['status']);
  }

  workEstimateRequest() {
    WorkEstimateRequest request = new WorkEstimateRequest();
    request.issues = this.issues;
    return request;
  }

  static _mapIssues(List<dynamic> response) {
    List<Issue> issues = [];
    response.forEach((item) {
      issues.add(Issue.fromJson(item));
    });
    return issues;
  }
}
