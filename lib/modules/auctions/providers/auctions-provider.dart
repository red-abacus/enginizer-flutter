import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car-make.service.dart';
import 'package:flutter/foundation.dart';

class AuctionsProvider with ChangeNotifier {
  CarMakeService carMakeService = inject<CarMakeService>();

  List<CarBrand> carBrands = [];



  Future<List<CarBrand>> loadCarBrands() async {
    carBrands = await carMakeService.getCarBrands();
    notifyListeners();
    return carBrands;
  }
}