import 'package:app/modules/appointments/model/provider/service-provider.model.dart';
import 'package:app/modules/appointments/model/service-item.model.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/modules/mechanic-appointments/models/mechanic-task.model.dart';
import 'package:app/modules/work-estimate-form/models/issue-recommendation.model.dart';
import 'package:app/modules/work-estimate-form/models/issue.model.dart';
import 'package:app/modules/authentication/models/user.model.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/utils/date_utils.dart';

import 'appointment-status.model.dart';

class AppointmentDetail {
  int id;
  String name;
  Car car;
  List<Issue> issues = [];
  List<ServiceItem> serviceItems = [];
  String scheduledDate;
  User user;
  List<int> workEstimateIds;
  ServiceProvider serviceProvider;
  AppointmentStatus status;
  String providerAcceptedDateTime;
  int bidId;
  double forwardPaymentPercent;
  String timeToRespond;
  List<IssueRecommendation> recommendations;

  AppointmentDetail(
      {this.id,
      this.name,
      this.car,
      this.issues,
      this.serviceItems,
      this.scheduledDate,
      this.user,
      this.workEstimateIds,
      this.serviceProvider,
      this.status,
      this.providerAcceptedDateTime,
      this.bidId,
      this.forwardPaymentPercent,
      this.timeToRespond,
      this.recommendations});

  factory AppointmentDetail.fromJson(Map<String, dynamic> json) {
    print('appointment json ${json['id']}');
    return AppointmentDetail(
        id: json['id'] != null ? json['id'] : 0,
        name: json['name'] != null ? json['name'] : '',
        car: Car.fromJson(json["car"]),
        issues: json["issues"] != null ? _mapIssuesList(json["issues"]) : [],
        serviceItems:
            json["services"] != null ? _mapServiceItems(json["services"]) : [],
        scheduledDate: json["scheduledDateTime"],
        user: json["user"] != null ? User.fromJson(json["user"]) : null,
        workEstimateIds: json["workEstimateIds"] != null
            ? _mapWorkEstimateIds(json['workEstimateIds'])
            : [],
        serviceProvider: json['provider'] != null
            ? ServiceProvider.fromJson(json['provider'])
            : null,
        status: json['status'] != null
            ? AppointmentStatus.fromJson(json['status'])
            : null,
        providerAcceptedDateTime: json['providerAcceptedDateTime'] != null
            ? json['providerAcceptedDateTime']
            : '',
        bidId: json['bidId'] != null ? json['bidId'] : 0,
        forwardPaymentPercent: json['forwardPaymentPercent'] != null
            ? json['forwardPaymentPercent']
            : 0,
        timeToRespond:
            json['timeToRespond'] != null ? json['timeToRespond'] : '',
    recommendations: json['recommendations'] != null ? _mapRecommendations(json['recommendations']) : []);
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

  static _mapWorkEstimateIds(List<dynamic> response) {
    List<int> ids = [];
    response.forEach((item) {
      if (item is int) {
        ids.add(item);
      }
    });
    return ids;
  }

  static _mapRecommendations(List<dynamic> response) {
    List<IssueRecommendation> recommendations = [];
    response.forEach((item) {
      recommendations.add(IssueRecommendation.fromJson(item));
    });
    return recommendations;
  }

  bool hasWorkEstimate() {
    if (workEstimateIds.length > 0) {
      int lastWorkEstimate = workEstimateIds[workEstimateIds.length - 1];
      return lastWorkEstimate > 0;
    }

    return false;
  }

  int lastWorkEstimate() {
    if (workEstimateIds.length > 0) {
      int lastWorkEstimate = workEstimateIds[workEstimateIds.length - 1];

      if (lastWorkEstimate > 0) {
        return lastWorkEstimate;
      }
    }

    return 0;
  }

  List<MechanicTask> tasksFromIssues() {
    List<MechanicTask> tasks = [];

    for (Issue issue in this.issues) {
      tasks.add(MechanicTask.from(issue));
    }

    return tasks;
  }

  DateEntry getWorkEstimateDateEntry() {
    DateTime dateTime =
        DateUtils.dateFromString(providerAcceptedDateTime, 'dd/MM/yyyy HH:mm');

    if (dateTime == null) {
      dateTime = DateUtils.dateFromString(scheduledDate, 'dd/MM/yyyy HH:mm');
    }

    if (dateTime != null) {
      DateEntry dateEntry = new DateEntry(dateTime);
      dateEntry.status = DateEntryStatus.Booked;
      return dateEntry;
    }

    return null;
  }

  static String scheduledTimeFormat() {
    return "dd/MM/yyyy HH:mm";
  }

  bool canEditWorkEstimate() {
    switch (status.getState()) {
      case AppointmentStatusState.SCHEDULED:
      case AppointmentStatusState.IN_UNIT:
      case AppointmentStatusState.IN_WORK:
        return true;
      default:
        return false;
    }
  }
}
