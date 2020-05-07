import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/time-entry.dart';
import 'package:app/modules/consultant-appointments/models/employee-timeserie.dart';
import 'package:app/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

import 'issue-recommendation.model.dart';
import 'issue.model.dart';

class WorkEstimateRequest {
  List<Issue> issues = [];
  int percent;
  DateTime timeToRespond;
  EmployeeTimeSerie employeeTimeSerie;

  String isValid(BuildContext context) {
    for (Issue issue in issues) {
      if (issue.recommendations.length == 0) {
        return S.of(context).estimator_empty_items_warning;
      }

      for (IssueRecommendation section in issue.recommendations) {
        if (section.isNew) {
          return S.of(context).estimator_empty_section_warning;
        }

        if (section.items.length == 0) {
          return S.of(context).estimator_empty_items_warning;
        }
      }
    }

    if (employeeTimeSerie == null) {
      return S.of(context).estimator_date_warning;
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    map['proposedDate'] = this.employeeTimeSerie != null
        ? '${this.employeeTimeSerie.date} ${this.employeeTimeSerie.hour}'
        : '';

    List<dynamic> issuesList = [];

    for (Issue issue in issues) {
      issuesList.add(issue.toCreateJson());
    }

    map['issues'] = issuesList;
    map['forwardPaymentPercent'] = percent;
    map['timeToRespond'] =
        DateUtils.stringFromDate(timeToRespond, 'dd/MM/yyyy');

    return map;
  }
}
