import 'package:enginizer_flutter/modules/appointments/model/appointment.model.dart';
import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider.model.dart';

import 'estimator/issue.model.dart';

class BidDetails {
  int id;
  Appointment appointment;
  double cost;
  int coveredServicesCount;
  List<dynamic> covertServices;
  String createdDate;
  List<Issue> issues;
  ServiceProvider serviceProvider;
  String providerAcceptedDateTime;
  int requestedServicesCount;
  String status;
  int workEstimateId;

  BidDetails(
      {this.id,
      this.appointment,
      this.cost,
      this.coveredServicesCount,
      this.covertServices,
      this.createdDate,
      this.issues,
      this.serviceProvider,
      this.providerAcceptedDateTime,
      this.requestedServicesCount,
      this.status,
      this.workEstimateId});

  factory BidDetails.fromJson(Map<String, dynamic> json) {
    return BidDetails(
        id: json['id'],
        appointment: json['appointment'] != null
            ? Appointment.fromJson(json['appointment'])
            : null,
        cost: json['cost'],
        coveredServicesCount: json['coveredServicesCount'],
        covertServices:
            json['covertServices'] != null ? json['covertServices'] : [],
        createdDate: json['createdDate'],
        issues: json['issues'] != null ? _mapIssues(json['issues']) : [],
        serviceProvider: json['provider'] != null
            ? ServiceProvider.fromJson(json['provider'])
            : null,
        providerAcceptedDateTime: json['providerAcceptedDateTime'],
        requestedServicesCount: json['requestedServicesCount'],
        status: json['status'],
        workEstimateId: json['workEstimateId']);
  }

  static _mapIssues(List<dynamic> response) {
    List<Issue> issues = [];
    response.forEach((item) {
      issues.add(Issue.fromJson(item));
    });
    return issues;
  }
}
