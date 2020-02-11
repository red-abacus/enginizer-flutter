import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/auctions/models/response/auction-response.model.dart';
import 'package:enginizer_flutter/modules/auctions/services/auction.service.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car-make.service.dart';
import 'package:flutter/foundation.dart';

class AuctionsProvider with ChangeNotifier {
  CarMakeService carMakeService = inject<CarMakeService>();
  AuctionsService auctionsService = inject<AuctionsService>();

  List<CarBrand> carBrands = [];
  AuctionResponse auctionResponse;

  Future<List<CarBrand>> loadCarBrands() async {
    carBrands = await carMakeService.getCarBrands();
    notifyListeners();
    return carBrands;
  }

  Future<AuctionResponse> loadAuctions() async {
    auctionResponse = await auctionsService.getAuctions();
    notifyListeners();
    return auctionResponse;
  }
}