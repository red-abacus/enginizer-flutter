import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/services/provider.service.dart';
import 'package:app/modules/auctions/models/estimator/provider-item.model.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:app/modules/parts/models/part-create-request.modal.dart';
import 'package:flutter/cupertino.dart';

class PartCreateProvider with ChangeNotifier {
  CarMakeService _carMakeService = inject<CarMakeService>();
  ProviderService _providerService = inject<ProviderService>();

  PartCreateRequest request;
  GlobalKey<FormState> formState;

  List<CarBrand> brands = [];
  List<CarModel> carModels = [];
  List<CarType> carTypes = [];
  List<CarYear> carYears = [];
  List<CarFuelType> carFuelTypes = [];

  int maxFiles = 5;

  Map<String, dynamic> carFormState;

  initialise() {
    carFormState = {
      'brand': null,
      'model': null,
      'type': null,
      'year': null,
      'fuelType': null,
    };

    request = PartCreateRequest();
    formState = null;
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

  Future<List<CarType>> loadCarTypes(CarQuery query) async {
    try {
      carTypes = await _carMakeService.getCarTypes(query);
      notifyListeners();
      return carTypes;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarYear>> loadCarYears(CarQuery query) async {
    try {
      carYears = await _carMakeService.getCarYears(query);
      notifyListeners();
      return carYears;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarFuelType>> loadCarFuelTypes(CarQuery query) async {
    try {
      carFuelTypes = await _carMakeService.getCarFuelTypes(query);
      notifyListeners();
      return carFuelTypes;
    } catch (error) {
      throw (error);
    }
  }

  Future<ProviderItem> addProviderItem(int providerId) async {
    try {
      ProviderItem item =
          await _providerService.addProviderItem(providerId, request.toJson());
      notifyListeners();
      return item;
    } catch (error) {
      throw (error);
    }
  }
}
