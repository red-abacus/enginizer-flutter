import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/cars/models/car-brand.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-color.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-cylinder-capacity.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-model.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-power.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-query.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-transmissions.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-year.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car-make.service.dart';
import 'package:flutter/cupertino.dart';

class CarsMakeProvider with ChangeNotifier {
  List<CarBrand> brands = [];
  List<CarModel> carModels = [];
  List<CarYear> carYears = [];
  List<CarFuelType> carFuelTypes = [];
  List<CarCylinderCapacity> carCylinderCapacities = [];
  List<CarPower> carPowers = [];
  List<CarTransmission> carTransmissions = [];
  List<CarColor> carColors = [];

  Map<String, dynamic> carMakeFormState = {
    'brand': null,
    'model': null,
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
    'itpExpiryDate': null,
  };

  CarMakeService carMakeService = inject<CarMakeService>();

  Future<List<CarBrand>> loadCarBrands() async {
    brands = await carMakeService.getCarBrands();
    return brands;
  }

  Future<List<CarModel>> loadCarModel(CarQuery query) async {
    carModels = await carMakeService.getCarModels(query);
    return carModels;
  }

  Future<List<CarYear>> loadCarYears(CarQuery query) async {
    carYears = await carMakeService.getCarYears(query);
    return carYears;
  }

  Future<List<CarFuelType>> loadCarFuelTypes() async {
    carFuelTypes = await carMakeService.getCarFuelTypes();
    return carFuelTypes;
  }

  Future<List<CarCylinderCapacity>> loadCarCylinderCapacity(
      CarQuery query) async {
    carCylinderCapacities =
        await carMakeService.getCarCylinderCapacities(query);
    return carCylinderCapacities;
  }

  Future<List<CarPower>> loadCarPowers(query) async {
    carPowers = await carMakeService.getCarPowers(query);
    return carPowers;
  }

  Future<List<CarTransmission>> loadCarTransmissions() async {
    carTransmissions = await carMakeService.getCarTransmissions();
    return carTransmissions;
  }

  Future<List<CarColor>> loadCarColors() async {
    carColors = await carMakeService.getCarColors();
    return carColors;
  }
}
