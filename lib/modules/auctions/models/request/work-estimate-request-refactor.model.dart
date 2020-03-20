import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:enginizer_flutter/modules/appointments/model/time-entry.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-refactor.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/estimator/issue-section.model.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimateRequestRefactor {
  List<IssueRefactor> issues = [];
  DateEntry dateEntry;

  String isValid(BuildContext context) {
    for (IssueRefactor issueRefactor in issues) {
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
}
