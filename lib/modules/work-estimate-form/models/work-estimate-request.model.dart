import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

import 'issue-recommendation.model.dart';
import 'issue.model.dart';

class WorkEstimateRequest {
  List<Issue> issues = [];
//  DateEntry dateEntry;

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

//    if (dateEntry == null) {
//      return S.of(context).estimator_date_warning;
//    }

    return null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
//    map['proposedDate'] = this.dateEntry != null
//        ? DateUtils.stringFromDate(this.dateEntry.dateTime, 'dd/MM/yyyy HH:mm')
//        : '';

    List<dynamic> issuesList = [];

    for (Issue issue in issues) {
      issuesList.add(issue.toCreateJson());
    }

    map['issues'] = issuesList;

    return map;
  }
}
