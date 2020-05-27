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
      case AppointmentStatusState.ON_HOLD:
        return S.of(context).appointment_status_on_hold;
      case AppointmentStatusState.IN_UNIT:
        return S.of(context).appointment_status_in_unit;
      case AppointmentStatusState.IN_REVIEW:
        return S.of(context).appointment_status_in_review;
      case AppointmentStatusState.NEW:
        return S.of(context).appointment_status_new;
      case AppointmentStatusState.ACCEPTED:
        return S.of(context).appointment_status_accepted;
      case AppointmentStatusState.NONE:
        return '';
        break;
    }
  }

  static String status(AppointmentStatusState state) {
    switch (state) {
      case AppointmentStatusState.IN_REVIEW:
        return 'InReview';
      case AppointmentStatusState.IN_WORK:
        return 'InWork';
      case AppointmentStatusState.PENDING:
        return 'Pending';
      case AppointmentStatusState.SUBMITTED:
        return 'Submitted';
      case AppointmentStatusState.SCHEDULED:
        return 'Scheduled';
      case AppointmentStatusState.CANCELED:
        return 'Canceled';
      case AppointmentStatusState.OPEN_BID:
        return 'OpenBid';
      case AppointmentStatusState.DONE:
        return 'Done';
      case AppointmentStatusState.ON_HOLD:
        return 'OnHold';
      case AppointmentStatusState.IN_UNIT:
        return 'InUnit';
      case AppointmentStatusState.NEW:
        return 'NEW';
      case AppointmentStatusState.ACCEPTED:
        return 'ACCEPTED';
      default:
        return '';
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
      AppointmentStatusState.IN_REVIEW,
      AppointmentStatusState.ON_HOLD,
      AppointmentStatusState.DONE
    ];
  }

  static List<AppointmentStatusState> statusesMechanic() {
    return [
      AppointmentStatusState.NONE,
      AppointmentStatusState.IN_WORK,
      AppointmentStatusState.ON_HOLD,
      AppointmentStatusState.IN_UNIT,
      AppointmentStatusState.IN_REVIEW
    ];
  }

  static List<AppointmentStatusState> statusesParts() {
    return [AppointmentStatusState.NEW, AppointmentStatusState.ACCEPTED];
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
  ON_HOLD,
  IN_UNIT,
  IN_REVIEW,
  NEW,
  ACCEPTED
}
