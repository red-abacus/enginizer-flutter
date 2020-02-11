import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/enum/auction-status.enum.dart';
import 'package:enginizer_flutter/modules/auctions/models/auction.model.dart';
import 'package:enginizer_flutter/modules/auctions/models/response/auction-response.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/auction.service.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car-make.service.dart';
import 'package:flutter/foundation.dart';

class AuctionsProvider with ChangeNotifier {
  CarMakeService carMakeService = inject<CarMakeService>();
  AuctionsService auctionsService = inject<AuctionsService>();

  AuctionStatus filterStatus;
  CarBrand filterCarBrand;

  List<CarBrand> carBrands = [];
  List<Auction> auctions = [];

  AuctionResponse auctionResponse;

  Future<List<CarBrand>> loadCarBrands() async {
    carBrands = await carMakeService.getCarBrands();
    notifyListeners();
    return carBrands;
  }

  Future<AuctionResponse> loadAuctions() async {
    auctionResponse = await auctionsService.getAuctions();
    this.auctions = auctionResponse.auctions;

    notifyListeners();
    return auctionResponse;
  }

  Future<List<Auction>> filterAuctions({String filterValue = ''}) async {
    auctions = auctionResponse.auctions;

    if (filterValue.isNotEmpty) {
      auctions = auctions.where((auction) => auction.filtered(filterValue)).toList();
    }

    notifyListeners();
    return auctions;
  }
}