import 'package:app/modules/auctions/enum/auction-status.enum.dart';

class AuctionRequest {
  AuctionStatus filterStatus;
  String searchString;
  int auctionPage = 0;
  int pageSize = 20;
  List<String> ids = [];

  toJson() {
    Map<String, dynamic> queryParameters = {'page': '$auctionPage'};

    if (filterStatus != null) {
      queryParameters['status'] =
          AuctionStatusUtils.rawStringFromStatus(filterStatus);
    }

    if (searchString != null) {
      queryParameters['search'] = searchString;
    }

    if (pageSize != null) {
      queryParameters['pageSize'] = '$pageSize';
    }

    if (ids.length > 0) {
      queryParameters['ids'] = ids;
    }

    return queryParameters;
  }
}
