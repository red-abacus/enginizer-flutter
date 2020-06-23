import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-variant.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/shop/models/shop-alert.model.dart';
import 'package:app/modules/shop/services/shop.service.dart';
import 'package:flutter/cupertino.dart';

class ShopAlertMakeProvider with ChangeNotifier {
  CarMakeService _carMakeService = inject<CarMakeService>();
  ShopService _shopService = inject<ShopService>();

  List<CarBrand> brands = [];
  List<CarModel> carModels = [];

  ShopAlert shopAlert;

  initParams() {
    brands = [];
    carModels = [];
    shopAlert = ShopAlert();
  }

  bool validShopAlert() {
    return shopAlert.brand != null ||
        shopAlert.brand != null ||
        shopAlert.brand != null ||
        shopAlert.brand != null ||
        shopAlert.brand != null ||
        shopAlert.brand != null ||
        shopAlert.brand != null ||
        shopAlert.brand  != null;
  }

  Future<List<CarBrand>> loadCarBrands(CarQuery carQuery) async {
    try {
      brands = await _carMakeService.getCarBrands(carQuery);
      notifyListeners();
      return brands;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarModel>> loadCarModel(CarQuery query) async {
    try {
      carModels = await _carMakeService.getCarModels(query);
      notifyListeners();
      return carModels;
    } catch (error) {
      throw (error);
    }
  }

  Future<ShopAlert> createShopAlert(ShopAlert shopAlert) async {
    try {
      ShopAlert result = await _shopService.createShopAlert(shopAlert);
      notifyListeners();
      return result;
    }
    catch (error) {
      throw(error);
    }
  }
}
