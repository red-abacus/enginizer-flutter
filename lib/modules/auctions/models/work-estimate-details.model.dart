import 'package:app/modules/appointments/model/appointment/appointment.model.dart';
import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/requests/work-estimate-request.model.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-payment-status.enum.dart';

import '../../work-estimate-form/models/issue.model.dart';

class WorkEstimateDetails {
  int id;
  Appointment appointment;
  Car car;
  String createdDate;
  List<Issue> issues;
  ServiceProvider serviceProvider;
  WorkEstimateStatus status;
  double totalCost;
  WorkEstimatePaymentStatus paymentStatus;

  WorkEstimateDetails(
      {this.id,
      this.appointment,
      this.car,
      this.createdDate,
      this.issues,
      this.serviceProvider,
      this.status,
      this.totalCost,
      this.paymentStatus});

  factory WorkEstimateDetails.fromJson(Map<String, dynamic> json) {
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
        status: json['status'] != null
            ? WorkEstimateStatusUtils.fromString(json['status'])
            : null,
        totalCost: json['totalCost'] != null ? json['totalCost'] : 0.0,
        paymentStatus: json['paymentStatus'] != null
            ? WorkEstimatePaymentStatusUtils.status(json['paymentStatus'])
            : null);
  }

  workEstimateRequest(EstimatorMode estimatorMode) {
    WorkEstimateRequest request = new WorkEstimateRequest(estimatorMode);
    request.issues = this.issues;
    return request;
  }

  finalWorkEstimateRequest(EstimatorMode estimatorMode) {
    WorkEstimateRequest request = new WorkEstimateRequest(estimatorMode);
    this.issues.forEach((issue) {
      List<IssueRecommendation> recommendations = [];
      issue.recommendations.forEach((recommendation) {
        if (!recommendation.isStandard) {
          recommendations.add(recommendation);
        }
      });
      issue.recommendations = recommendations;
    });
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
