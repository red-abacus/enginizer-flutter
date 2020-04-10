import 'package:app/generated/l10n.dart';
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
      case AppointmentStatusState.DONE:
        return S.of(context).appointment_status_done;
      case AppointmentStatusState.NONE:
        return '';
        break;
    }
  }

  static List<AppointmentStatusState> statuses() {
    return [
      AppointmentStatusState.NONE,
      AppointmentStatusState.SUBMITTED,
      AppointmentStatusState.PENDING,
      AppointmentStatusState.SCHEDULED,
      AppointmentStatusState.IN_WORK,
      AppointmentStatusState.OPEN_BID,
      AppointmentStatusState.CANCELED,
      AppointmentStatusState.DONE
    ];
  }
}

enum AppointmentStatusState {
  NONE,
  SUBMITTED,
  IN_WORK,
  PENDING,
  SCHEDULED,
  CANCELED,
  OPEN_BID,
  DONE,
}
