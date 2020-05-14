import 'package:app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';

class AuctionStatusUtils {
  static AuctionStatus statusFromString(String sender) {
    switch (sender.toLowerCase()) {
      case 'open':
        return AuctionStatus.OPEN;
      case 'closed':
        return AuctionStatus.FINISHED;
      default:
        break;
    }

    return null;
  }

  static List<AuctionStatus> statuses() {
    return [AuctionStatus.OPEN, AuctionStatus.FINISHED, AuctionStatus.ALL];
  }

  static titleFromStatus(AuctionStatus status, BuildContext context) {
    if (status != null) {
      switch (status) {
        case AuctionStatus.OPEN:
          return S.of(context).general_auction;
        case AuctionStatus.FINISHED:
          return S.of(context).auctions_finished;
        case AuctionStatus.ALL:
          return S.of(context).general_all;
      }
    }

    return '';
  }

  static rawStringFromStatus(AuctionStatus status) {
    switch (status) {
      case AuctionStatus.OPEN:
        return 'OPEN';
      case AuctionStatus.FINISHED:
        return 'CLOSED';
      default:
        break;
    }
  }
}

enum AuctionStatus { OPEN, FINISHED, ALL }
