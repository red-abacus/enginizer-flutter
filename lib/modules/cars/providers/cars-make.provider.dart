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
import 'package:flutter/cupertino.dart';

class CarsMakeProvider with ChangeNotifier {
  List<CarBrand> brands = [];
  List<CarModel> carModels = [];
  List<CarType> carTypes = [];
  List<CarYear> carYears = [];
  List<CarFuelType> carFuelTypes = [];
  List<CarColor> carColors = [];
  List<CarVariant> carVariants = [];

  Map<String, dynamic> carMakeFormState = {
    'brand': null,
    'model': null,
  };

  Map<String, dynamic> carTechnicalFormState = {
    'type': null,
    'year': null,
    'fuelType': null,
    'color': null,
    'variant': null,
    'vin': null
  };

  Map<String, dynamic> carExtraFormState = {
    'registrationNumber': null,
    'mileage': null,
    'rcaExpiryDate': null,
    'rcaExpiryDateNotification': false,
    'itpExpiryDate': null,
    'itpExpiryDateNotification': false
  };

  initParams() {
    brands = [];
    carModels = [];
    carTypes = [];
    carYears = [];
    carFuelTypes = [];
    carColors = [];
    carVariants = [];

    carMakeFormState['brand'] = null;
    carMakeFormState['model'] = null;

    carTechnicalFormState['type'] = null;
    carTechnicalFormState['year'] = null;
    carTechnicalFormState['fuelType'] = null;
    carTechnicalFormState['color'] = null;
    carTechnicalFormState['vin'] = null;
    carTechnicalFormState['variant'] = null;

    carExtraFormState['registrationNumber'] = null;
    carExtraFormState['mileage'] = null;
    carExtraFormState['rcaExpiryDate'] = null;
    carExtraFormState['rcaExpiryDateNotification'] = false;
    carExtraFormState['itpExpiryDate'] = null;
    carExtraFormState['itpExpiryDateNotification'] = false;
  }

  CarMakeService carMakeService = inject<CarMakeService>();

  Future<List<CarBrand>> loadCarBrands(CarQuery carQuery) async {
    brands = await carMakeService.getCarBrands(carQuery);
    notifyListeners();
    return brands;
  }

  Future<List<CarModel>> loadCarModel(CarQuery query) async {
    carModels = await carMakeService.getCarModels(query);
    notifyListeners();
    return carModels;
  }

  Future<List<CarType>> loadCarTypes(CarQuery query) async {
    carTypes = await carMakeService.getCarTypes(query);
    notifyListeners();
    return carTypes;
  }

  Future<List<CarYear>> loadCarYears(CarQuery query) async {
    carYears = await carMakeService.getCarYears(query);
    notifyListeners();
    return carYears;
  }

  Future<List<CarFuelType>> loadCarFuelTypes(CarQuery query) async {
    carFuelTypes = await carMakeService.getCarFuelTypes(query);
    notifyListeners();
    return carFuelTypes;
  }

  Future<List<CarColor>> loadCarColors() async {
    carColors = await carMakeService.getCarColors();
    notifyListeners();
    return carColors;
  }

  Future<List<CarVariant>> loadCarVariants(CarQuery query) async {
    carVariants = await carMakeService.getCarVariants(query);
    notifyListeners();
    return carVariants;
  }
}
