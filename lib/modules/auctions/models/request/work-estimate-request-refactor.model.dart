import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-refactor.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';

class WorkEstimateRequestRefactor {
  List<IssueRefactor> issues = [];
  DateEntry dateEntry;

  bool isValid() {
    bool valid = true;

    for (IssueRefactor issue in issues) {
      if (issue.sections.length == 0) {
        valid = false;
        break;
      }
      else {
        for(IssueSection section in issue.sections) {
          if (section.items.length == 0) {
            valid = false;
            break;
          }
        }
      }
    }

    valid = dateEntry != null;

    return valid;
  }
}