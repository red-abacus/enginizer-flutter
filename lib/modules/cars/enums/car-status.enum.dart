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
      case 'FOR_RENT':
        return CarStatus.ForRent;
      default:
        break;
    }

    return null;
  }

  static titleFromStatus(CarStatus status, BuildContext context) {
    if (status != null) {
      switch (status) {
        case CarStatus.ForSell:
          return S.of(context).car_status_for_sell;
        case CarStatus.Pending:
          return S.of(context).auctions_finished;
        case CarStatus.Sold:
          return S.of(context).car_status_sold;
        case CarStatus.ForRent:
          return S.of(context).car_status_for_rent;
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
      case CarStatus.ForRent:
        return 'FOR_RENT';

    }
  }
}

enum CarStatus { Pending, ForSell, Sold, ForRent }
