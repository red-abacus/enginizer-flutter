import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/personnel/employee-timeserie.dart';
import 'package:app/modules/appointments/model/personnel/time-entry.dart';
import 'package:app/modules/work-estimate-form/enums/estimator-mode.enum.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

import '../issue-recommendation.model.dart';
import '../issue.model.dart';

class WorkEstimateRequest {
  List<Issue> issues = [];
  int percent;
  DateTime timeToRespond;

//  EmployeeTimeSerie employeeTimeSerie;
  DateEntry dateEntry;

  final EstimatorMode estimatorMode;

  WorkEstimateRequest(this.estimatorMode);

  void setIssues(BuildContext context, List<Issue> issues) {
    this.issues = issues;

    if (estimatorMode == EstimatorMode.Create) {
      this.issues.forEach((issue) {
        issue.recommendations
            .add(IssueRecommendation.defaultRecommendation(context));
      });
    } else if (estimatorMode == EstimatorMode.CreatePr) {
      this.issues.forEach((issue) {
        issue.recommendations
            .add(IssueRecommendation.defaultPrRecommendation(context));
      });
    }
  }

  String isValid(BuildContext context, EstimatorMode estimatorMode) {
    for (Issue issue in issues) {
      if (issue.recommendations.length == 0 &&
          estimatorMode != EstimatorMode.CreatePart) {
        return S.of(context).estimator_empty_items_warning;
      }

      for (IssueRecommendation section in issue.recommendations) {
        if (section.items.length == 0 &&
            estimatorMode != EstimatorMode.CreatePart) {
          return S.of(context).estimator_empty_items_warning;
        }
      }
    }

    if (estimatorMode == EstimatorMode.Create ||
        estimatorMode == EstimatorMode.CreatePr) {
      if (dateEntry == null) {
        return S.of(context).auction_proposed_date_error;
      }
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
//    map['proposedDate'] = this.employeeTimeSerie != null
//        ? '${this.employeeTimeSerie.date} ${this.employeeTimeSerie.hour}'
//        : '';

    List<dynamic> issuesList = [];

    for (Issue issue in issues) {
      issuesList.add(issue.toCreateJson(estimatorMode));
    }

    map['issues'] = issuesList;
    map['forwardPaymentPercent'] = percent;
    map['timeToRespond'] =
        DateUtils.stringFromDate(timeToRespond, 'dd/MM/yyyy');

    if (estimatorMode == EstimatorMode.Create) {
      map['proposedDate'] =
          DateUtils.stringFromDate(dateEntry.dateTime, 'dd/MM/yyyy HH:mm');
    } else if (estimatorMode == EstimatorMode.CreatePart) {
      map['proposedDate'] =
          DateUtils.stringFromDate(timeToRespond, 'dd/MM/yyyy HH:mm');
    } else if (estimatorMode == EstimatorMode.CreatePr && dateEntry != null) {
      map['proposedDate'] =
          DateUtils.stringFromDate(dateEntry.dateTime, 'dd/MM/yyyy HH:mm');
    }
    return map;
  }

  totalCost() {
    double total = 0.0;

    this.issues.forEach((issue) {
      total += issue.totalCost();
    });

    return total;
  }
}
