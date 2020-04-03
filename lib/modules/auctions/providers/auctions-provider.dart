import 'package:app/config/injection.dart';
import 'package:app/modules/auctions/enum/auction-status.enum.dart';
import 'package:app/modules/auctions/models/auction.model.dart';
import 'package:app/modules/auctions/models/response/auction-response.model.dart';
import 'package:app/modules/auctions/services/auction.service.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
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
    return carBrands;
  }

  Future<AuctionResponse> loadAuctions() async {
    auctionResponse = await auctionsService.getAuctions();
    this.auctions = auctionResponse.auctions;
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

  void resetParameters() {
    this.filterStatus = null;
    this.filterCarBrand = null;
    this.searchString = "";

    carBrands = [];
    auctions = [];
  }
}
