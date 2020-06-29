import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class CarStatusUtils {
  static CarStatus statusFromString(String sender) {
    switch (sender) {
      case 'PENDING':
        return CarStatus.Pending;
      case 'FOR_SELL':
        return CarStatus.ForSell;
      case 'SOLD':
        return CarStatus.Sold;
      default:
        break;
    }

    return null;
  }

  static titleFromStatus(CarStatus status, BuildContext context) {
    if (status != null) {
      switch (status) {
        case CarStatus.ForSell:
          return S.of(context).general_auction;
        case CarStatus.Pending:
          return S.of(context).auctions_finished;
        case CarStatus.Sold:
          return S.of(context).car_status_sold;
          break;
      }
    }

    return '';
  }

  static rawStringFromStatus(CarStatus status) {
    switch (status) {
      case CarStatus.Pending:
        return 'OPEN';
      case CarStatus.ForSell:
        return 'FOR_SELL';
      case CarStatus.Sold:
        return "SOLD";
    }
  }
}

enum CarStatus { Pending, ForSell, Sold }
