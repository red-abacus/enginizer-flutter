import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class PromotionStatusUtils {
  static PromotionStatus fromString(String sender) {
    switch (sender.toLowerCase()) {
      case 'active':
        return PromotionStatus.Active;
      case 'paused':
        return PromotionStatus.Paused;
      case 'finished':
        return PromotionStatus.Finished;
      case 'pending':
        return PromotionStatus.Pending;
    }

    return null;
  }

  static String status(PromotionStatus state) {
    switch (state) {
      case PromotionStatus.Active:
        return 'ACTIVE';
      case PromotionStatus.Paused:
        return 'PAUSED';
      case PromotionStatus.Finished:
        return 'FINISHED';
      case PromotionStatus.Pending:
        return 'PENDING';
      default:
        return '';
    }
  }

  static String title(BuildContext context, PromotionStatus state) {
    switch (state) {
      case PromotionStatus.Active:
        return S.of(context).promotions_status_active;
      case PromotionStatus.Paused:
        return S.of(context).promotions_status_paused;
      case PromotionStatus.Finished:
        return S.of(context).appointment_status_finished;
      case PromotionStatus.Pending:
        return S.of(context).appointment_status_pending;
        break;
    }
  }
}

enum PromotionStatus {
  Pending,
  Active,
  Paused,
  Finished,
}
