import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';
import 'package:flutter/cupertino.dart';

import 'issue-section.model.dart';
import 'issue.model.dart';

class WorkEstimateRequest {
  List<Issue> issues = [];
  DateEntry dateEntry;

  String isValid(BuildContext context) {
    for (Issue issueRefactor in issues) {
      if (issueRefactor.sections.length == 0) {
        return S.of(context).estimator_empty_items_warning;
      }

      for (IssueSection section in issueRefactor.sections) {
        if (section.isNew) {
          return S.of(context).estimator_empty_section_warning;
        }

        if (section.items.length == 0) {
          return S.of(context).estimator_empty_items_warning;
        }
      }
    }

    if (dateEntry == null) {
      return S.of(context).estimator_date_warning;
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = new Map();
    map['proposedDate'] = this.dateEntry != null
        ? DateUtils.stringFromDate(this.dateEntry.dateTime, 'dd/MM/yyyy HH:mm')
        : '';
    // TODO - need to change when API structure is defined
    return map;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> map = new Map();
    map['proposedDate'] = this.dateEntry != null
        ? DateUtils.stringFromDate(this.dateEntry.dateTime, 'dd/MM/yyyy HH:mm')
        : '';
    // TODO - need to change when API structure is defined
    return map;
  }
}
