import 'package:app/config/injection.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/response/auction-response.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:flutter/foundation.dart';

class AuctionsProvider with ChangeNotifier {
  CarMakeService carMakeService = inject<CarMakeService>();
  AuctionsService auctionsService = inject<AuctionsService>();

  AuctionStatus filterStatus;
  String searchString;
  List<Auction> auctions = [];

  AuctionResponse auctionResponse;

  int _auctionPage = 0;
  int _pageSize = 20;

  void resetParameters() {
    _auctionPage = 0;
    this.filterStatus = null;
    this.searchString = null;

    auctions = [];
  }

  Future<AuctionResponse> loadAuctions() async {
    if (auctionResponse != null) {
      if (_auctionPage >= auctionResponse.totalPages) {
        return null;
      }
    }

    try {
      auctionResponse = await auctionsService.getAuctions(_auctionPage,
          pageSize: _pageSize,
          searchString: this.searchString,
          status: AuctionStatusUtils.rawStringFromStatus(this.filterStatus));
      this.auctions.addAll(auctionResponse.auctions);
      _auctionPage += 1;
      return auctionResponse;
    } catch (error) {
      throw (error);
    }
  }

  filterAuctions(String searchString, AuctionStatus filterStatus) {
    this._auctionPage = 0;
    this.auctionResponse = null;
    this.auctions = [];

    this.searchString = searchString;
    this.filterStatus = filterStatus;
  }
}
