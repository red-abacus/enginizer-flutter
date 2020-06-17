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
    'vin': null,
    'start_year': null,
    'end_year': null,
    'start_mileage': null,
    'end_mileage': null,
    'start_price': null,
    'end_price': null
  };

  Map<String, dynamic> carExtraFormState = {
    'registrationNumber': null,
    'mileage': null,
    'rcaExpiryDate': null,
    'rcaExpiryDateNotification': false,
    'itpExpiryDate': null,
    'itpExpiryDateNotification': false,
    'exhaust': null,
    'diagnosisProtocol': null,
    'generalVerification': null
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

    carTechnicalFormState = {
      'type': null,
      'year': null,
      'fuelType': null,
      'color': null,
      'variant': null,
      'vin': null,
      'start_year': null,
      'end_year': null,
      'start_mileage': null,
      'end_mileage': null,
      'start_price': null,
      'end_price': null
    };

    carExtraFormState['registrationNumber'] = null;
    carExtraFormState['mileage'] = null;
    carExtraFormState['rcaExpiryDate'] = null;
    carExtraFormState['rcaExpiryDateNotification'] = false;
    carExtraFormState['itpExpiryDate'] = null;
    carExtraFormState['itpExpiryDateNotification'] = false;
  }

  bool validShopAlert() {
    return carMakeFormState['brand'] != null ||
        carMakeFormState['model'] != null ||
        carTechnicalFormState['start_year'] != null ||
        carTechnicalFormState['endYear'] != null ||
        carTechnicalFormState['start_mileage'] != null ||
        carTechnicalFormState['end_year'] != null ||
        carTechnicalFormState['start_price'] != null ||
        carTechnicalFormState['end_price'] != null;
  }

  CarMakeService carMakeService = inject<CarMakeService>();

  Future<List<CarBrand>> loadCarBrands(CarQuery carQuery) async {
    try {
      brands = await carMakeService.getCarBrands(carQuery);
      notifyListeners();
      return brands;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarModel>> loadCarModel(CarQuery query) async {
    try {
      carModels = await carMakeService.getCarModels(query);
      notifyListeners();
      return carModels;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarType>> loadCarTypes(CarQuery query) async {
    try {
      carTypes = await carMakeService.getCarTypes(query);
      notifyListeners();
      return carTypes;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarYear>> loadCarYears(CarQuery query) async {
    try {
      carYears = await carMakeService.getCarYears(query);
      notifyListeners();
      return carYears;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarFuelType>> loadCarFuelTypes(CarQuery query) async {
    try {
      carFuelTypes = await carMakeService.getCarFuelTypes(query);
      notifyListeners();
      return carFuelTypes;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarColor>> loadCarColors() async {
    try {
      carColors = await carMakeService.getCarColors();
      notifyListeners();
      return carColors;
    } catch (error) {
      throw (error);
    }
  }

  Future<List<CarVariant>> loadCarVariants(CarQuery query) async {
    try {
      carVariants = await carMakeService.getCarVariants(query);
      notifyListeners();
      return carVariants;
    } catch (error) {
      throw (error);
    }
  }
}
