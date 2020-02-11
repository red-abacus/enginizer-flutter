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
  String searchString = "";

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

  Future<List<Auction>> filterAuctions(String searchString,
      AuctionStatus filterStatus, CarBrand filterCarBrand) async {
    this.searchString = searchString;
    this.filterStatus = filterStatus;
    this.filterCarBrand = filterCarBrand;

    auctions = auctionResponse.auctions;

    auctions = auctions
        .where((auction) => auction.filtered(
            this.searchString, this.filterStatus, this.filterCarBrand))
        .toList();
    notifyListeners();
    return auctions;
  }
}
