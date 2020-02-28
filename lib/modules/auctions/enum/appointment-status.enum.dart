import 'package:enginizer_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class AppointmentStatusStateUtils {
  static String title(BuildContext context, AppointmentStatusState state) {
    switch (state) {
      case AppointmentStatusState.IN_WORK:
        return S.of(context).appointment_status_in_work;
      case AppointmentStatusState.PENDING:
        return S.of(context).appointment_status_pending;
      case AppointmentStatusState.SUBMITTED:
        return S.of(context).appointment_status_submitted;
      case AppointmentStatusState.SCHEDULED:
        return S.of(context).appointment_status_scheduled;
      case AppointmentStatusState.CANCELED:
        return S.of(context).appointment_status_canceled;
      case AppointmentStatusState.OPEN_BID:
        return S.of(context).appointment_status_open_bid;
      case AppointmentStatusState.COMPLETED:
        return S.of(context).appointment_status_completed;
      case AppointmentStatusState.ALL:
        return S.of(context).general_all;
        break;
    }
  }

  static List<AppointmentStatusState> statuses() {
    return [
      AppointmentStatusState.ALL,
      AppointmentStatusState.SUBMITTED,
      AppointmentStatusState.PENDING,
      AppointmentStatusState.SCHEDULED,
      AppointmentStatusState.IN_WORK,
      AppointmentStatusState.OPEN_BID,
      AppointmentStatusState.CANCELED,
      AppointmentStatusState.COMPLETED
    ];
  }
}

enum AppointmentStatusState {
  ALL,
  SUBMITTED,
  IN_WORK,
  PENDING,
  SCHEDULED,
  CANCELED,
  OPEN_BID,
  COMPLETED
}
