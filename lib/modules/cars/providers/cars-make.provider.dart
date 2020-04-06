import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car-brand.model.dart';
import 'package:app/modules/cars/models/car-color.model.dart';
import 'package:app/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:app/modules/cars/models/car-fuel.model.dart';
import 'package:app/modules/cars/models/car-model.model.dart';
import 'package:app/modules/cars/models/car-power.model.dart';
import 'package:app/modules/cars/models/car-query.model.dart';
import 'package:app/modules/cars/models/car-transmissions.model.dart';
import 'package:app/modules/cars/models/car-type.model.dart';
import 'package:app/modules/cars/models/car-year.model.dart';
import 'package:app/modules/cars/services/car-make.service.dart';
import 'package:flutter/cupertino.dart';

class CarsMakeProvider with ChangeNotifier {
  List<CarBrand> brands = [];
  List<CarModel> carModels = [];
  List<CarType> carTypes = [];
  List<CarYear> carYears = [];
  List<CarFuelType> carFuelTypes = [];
  List<CarCylinderCapacity> carCylinderCapacities = [];
  List<CarPower> carPowers = [];
  List<CarTransmission> carTransmissions = [];
  List<CarColor> carColors = [];

  Map<String, dynamic> carMakeFormState = {
    'brand': null,
    'model': null,
    'type': null,
    'year': null,
    'fuelType': null
  };

  Map<String, dynamic> carTechnicalFormState = {
    'cylinderCapacity': null,
    'power': null,
    'transmission': null,
    'color': null,
    'vin': null
  };

  Map<String, dynamic> carExtraFormState = {
    'registrationNumber': null,
    'activeKm': null,
    'rcaExpiryDate': null,
    'rcaExpiryDateNotification': false,
    'itpExpiryDate': null,
    'itpExpiryDateNotification': false
  };

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

  Future<List<CarCylinderCapacity>> loadCarCylinderCapacity(
      CarQuery query) async {
    carCylinderCapacities =
        await carMakeService.getCarCylinderCapacities(query);
    notifyListeners();
    return carCylinderCapacities;
  }

  Future<List<CarPower>> loadCarPowers(query) async {
    carPowers = await carMakeService.getCarPowers(query);
    notifyListeners();
    return carPowers;
  }

  Future<List<CarTransmission>> loadCarTransmissions() async {
    carTransmissions = await carMakeService.getCarTransmissions();
    notifyListeners();
    return carTransmissions;
  }

  Future<List<CarColor>> loadCarColors() async {
    carColors = await carMakeService.getCarColors();
    notifyListeners();
    return carColors;
  }
}
