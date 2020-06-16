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
      case AppointmentStatusState.IN_TRANSPORT:
        return S.of(context).appointment_status_in_transport;
      case AppointmentStatusState.NONE:
        return '';
        break;
    }
  }

  static String status(AppointmentStatusState state) {
    switch (state) {
      case AppointmentStatusState.IN_REVIEW:
        return 'IN_REVIEW';
      case AppointmentStatusState.IN_WORK:
        return 'IN_WORK';
      case AppointmentStatusState.PENDING:
        return 'PENDING';
      case AppointmentStatusState.SUBMITTED:
        return 'SUBMITTED';
      case AppointmentStatusState.SCHEDULED:
        return 'SCHEDULED';
      case AppointmentStatusState.CANCELED:
        return 'CANCELED';
      case AppointmentStatusState.OPEN_BID:
        return 'OPEN_BID';
      case AppointmentStatusState.DONE:
        return 'DONE';
      case AppointmentStatusState.ON_HOLD:
        return 'ON_HOLD';
      case AppointmentStatusState.IN_UNIT:
        return 'IN_UNIT';
      case AppointmentStatusState.NEW:
        return 'NEW';
      case AppointmentStatusState.ACCEPTED:
        return 'ACCEPTED';
      case AppointmentStatusState.IN_TRANSPORT:
        return 'IN_TRANSPORT';
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
      AppointmentStatusState.IN_TRANSPORT,
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
    return [AppointmentStatusState.NEW, AppointmentStatusState.ACCEPTED, AppointmentStatusState.DONE];
  }

  static List<AppointmentStatusState> statusesPr() {
    return [AppointmentStatusState.SUBMITTED, AppointmentStatusState.SCHEDULED, AppointmentStatusState.IN_TRANSPORT];
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
  ACCEPTED,
  IN_TRANSPORT
}
