import 'package:app/config/injection.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/request/auction-request.model.dart';
import 'package:app/modules/auctions/models/response/auction-response.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:flutter/foundation.dart';

class AuctionsProvider with ChangeNotifier {
  CarMakeService carMakeService = inject<CarMakeService>();
  AuctionsService auctionsService = inject<AuctionsService>();

  List<Auction> auctions = [];

  AuctionResponse auctionResponse;
  AuctionRequest auctionRequest;

  void resetParameters() {
    auctionRequest = AuctionRequest();
    auctions = [];
  }

  Future<AuctionResponse> loadAuctions() async {
    if (auctionResponse != null) {
      if (auctionRequest.auctionPage >= auctionResponse.totalPages) {
        return null;
      }
    }

    try {
      auctionResponse = await auctionsService.getAuctions(auctionRequest);
      this.auctions.addAll(auctionResponse.auctions);
      auctionRequest.auctionPage += 1;
      return auctionResponse;
    } catch (error) {
      throw (error);
    }
  }

  filterAuctions(String searchString, AuctionStatus filterStatus) {
    auctionRequest.auctionPage = 0;
    this.auctionResponse = null;
    this.auctions = [];

    auctionRequest.searchString = searchString;
    auctionRequest.filterStatus = filterStatus;
  }
}
