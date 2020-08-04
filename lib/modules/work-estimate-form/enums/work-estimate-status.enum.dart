import 'package:app/generated/l10n.dart';
import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimateStatusUtils {
  static WorkEstimateStatus fromString(String sender) {
    switch (sender.toLowerCase()) {
      case 'pending':
        return WorkEstimateStatus.Pending;
      case 'accepted':
        return WorkEstimateStatus.Accepted;
      case 'rejected':
        return WorkEstimateStatus.Rejected;
      case 'new':
        return WorkEstimateStatus.New;
    }

    return null;
  }

  static String value(WorkEstimateStatus status) {
    switch (status) {
      case WorkEstimateStatus.Pending:
        return 'PENDING';
      case WorkEstimateStatus.Rejected:
        return 'REJECTED';
      case WorkEstimateStatus.Accepted:
        return 'ACCEPTED';
      case WorkEstimateStatus.New:
        return 'NEW';
    }
  }

  static String title(BuildContext context, WorkEstimateStatus status) {
    if (status != null) {
      switch (status) {
        case WorkEstimateStatus.Pending:
          return S.of(context).work_estimate_status_pending;
        case WorkEstimateStatus.Accepted:
          return S.of(context).work_estimate_status_accepted;
        case WorkEstimateStatus.Rejected:
          return S.of(context).work_estimate_status_rejected;
        case WorkEstimateStatus.New:
          return S.of(context).work_estimate_status_new;
      }
    }

    return '';
  }

  static Color color(WorkEstimateStatus status) {
    switch (status) {
      case WorkEstimateStatus.New:
      case WorkEstimateStatus.Pending:
        return yellow2;
      case WorkEstimateStatus.Rejected:
        return red;
      case WorkEstimateStatus.Accepted:
        return green;
    }
  }

  static List<WorkEstimateStatus> list() {
    return [
      WorkEstimateStatus.New,
      WorkEstimateStatus.Pending,
      WorkEstimateStatus.Rejected,
      WorkEstimateStatus.Accepted
    ];
  }
}

enum WorkEstimateStatus { New, Pending, Rejected, Accepted }
