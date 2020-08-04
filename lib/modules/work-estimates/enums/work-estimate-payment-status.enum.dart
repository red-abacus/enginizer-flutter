import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class WorkEstimatePaymentStatusUtils {
  static WorkEstimatePaymentStatus status(String value) {
    switch (value) {
      case 'UNPAID':
        return WorkEstimatePaymentStatus.Unpaid;
      case 'PAID':
        return WorkEstimatePaymentStatus.Paid;
    }

    return null;
  }

  static String title(BuildContext context, WorkEstimatePaymentStatus status) {
    switch (status) {
      case WorkEstimatePaymentStatus.Paid:
        return S.of(context).work_estimate_payment_status_paid;
      case WorkEstimatePaymentStatus.Unpaid:
        return S.of(context).work_estimate_payment_status_unpaid;
        break;
    }
  }
}

enum WorkEstimatePaymentStatus { Paid, Unpaid }
