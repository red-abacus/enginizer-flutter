import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue.model.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';

class WorkEstimateRequest {
  List<Issue> issues = [];
  DateEntry dateEntry;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    map['proposedDate'] = this.dateEntry != null
        ? DateUtils.stringFromDate(this.dateEntry.dateTime, 'dd/MM/yyyy HH:mm')
        : '';

    List<dynamic> issuesList = [];

    for (Issue issue in issues) {
      issuesList.add(issue.toCreateJson());
    }

    map['estimateIssues'] = issuesList;
    return map;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> map = new Map();
    map['proposedDate'] = this.dateEntry != null
        ? DateUtils.stringFromDate(this.dateEntry.dateTime, 'dd/MM/yyyy HH:mm')
        : '';

    List<dynamic> issuesList = [];

    for (Issue issue in issues) {
      issuesList.add(issue.toCreateJson());
    }

    map['issues'] = issuesList;
    return map;
  }

  bool isValid() {
    bool valid = true;

    for (Issue issue in issues) {
      if (issue.items.length == 0) {
        valid = false;
        break;
      }
    }

    valid = dateEntry != null;

    return valid;
  }
}