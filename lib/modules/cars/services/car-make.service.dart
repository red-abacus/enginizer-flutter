import 'package:dio/dio.dart';
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
import 'package:enginizer_flutter/utils/environment.constants.dart';

class CarMakeService {
  static const String CAR_MAKE_API_PATH =
      '${Environment.CARS_BASE_API}/carmake';

  Dio _dio = inject<Dio>();

  CarMakeService();

  Future<List<CarBrand>> getCarBrands() async {
    print("load car brands !");
    final response = await _dio.get('$CAR_MAKE_API_PATH/brands');
    print("finish car brands !");

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapBrands(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_BRANDS_FAILED');
    }
  }

  Future<List<CarModel>> getCarModels(CarQuery query) async {
    final response = await _dio.get('$CAR_MAKE_API_PATH/models',
        queryParameters: {"brandId": query.brand.id});

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapModels(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_MODELS_FAILED');
    }
  }

  Future<List<CarYear>> getCarYears(CarQuery query) async {
    final response = await _dio.get('$CAR_MAKE_API_PATH/years',
        queryParameters: {
          "brandId": query.brand.id,
          "modelId": query.model.id
        });

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapYears(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_YEAR_FAILED');
    }
  }

  Future<List<CarFuelType>> getCarFuelTypes() async {
    final response = await _dio.get('$CAR_MAKE_API_PATH/fuelType');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapFuelTypes(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_FUEL_FAILED');
    }
  }

  Future<List<CarCylinderCapacity>> getCarCylinderCapacities(
      CarQuery query) async {
    final response =
        await _dio.get('$CAR_MAKE_API_PATH/cylinderCapacity', queryParameters: {
      'brandId': query.brand.id,
      'modelId': query.model.id,
      'year': query.year.id,
      'fuelType': query.fuelType.id
    });

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapCylinderCapacities(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_CC_FAILED');
    }
  }

  Future<List<CarPower>> getCarPowers(CarQuery query) async {
    final response =
        await _dio.get('$CAR_MAKE_API_PATH/power', queryParameters: {
      'brandId': query.brand.id,
      'modelId': query.model.id,
      'year': query.year.id,
      'fuelType': query.fuelType.id
    });

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapPowers(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_POWERS_FAILED');
    }
  }

  Future<List<CarTransmission>> getCarTransmissions() async {
    final response = await _dio.get('$CAR_MAKE_API_PATH/transmissions');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapTransmissions(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_TRANSMISSIONS_FAILED');
    }
  }

  Future<List<CarColor>> getCarColors() async {
    final response = await _dio.get('$CAR_MAKE_API_PATH/colors');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      return _mapColors(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('LOAD_CAR_COLORS_FAILED');
    }
  }

  _mapBrands(List<dynamic> brands) {
    List<CarBrand> brandList = [];
    brands.forEach((brnd) => brandList.add(CarBrand.fromJson(brnd)));
    return brandList;
  }

  _mapModels(List<dynamic> models) {
    List<CarModel> carModels = [];
    models.forEach((model) => carModels.add(CarModel.fromJson(model)));
    return carModels;
  }

  _mapYears(List<dynamic> years) {
    List<CarYear> carYears = [];
    years.forEach((model) => carYears.add(CarYear.fromJson(model)));
    return carYears;
  }

  _mapFuelTypes(List<dynamic> fuelTypes) {
    List<CarFuelType> carFuelTypes = [];
    fuelTypes.forEach((model) => carFuelTypes.add(CarFuelType.fromJson(model)));
    return carFuelTypes;
  }

  _mapCylinderCapacities(List<dynamic> cylinderCaps) {
    List<CarCylinderCapacity> cylinderCapacities = [];
    cylinderCaps.forEach(
        (model) => cylinderCapacities.add(CarCylinderCapacity.fromJson(model)));
    return cylinderCapacities;
  }

  _mapPowers(List<dynamic> powers) {
    List<CarPower> carPowers = [];
    powers.forEach((model) => carPowers.add(CarPower.fromJson(model)));
    return carPowers;
  }

  _mapTransmissions(List<dynamic> transmissions) {
    List<CarTransmission> carTransmissions = [];
    transmissions.forEach(
        (model) => carTransmissions.add(CarTransmission.fromJson(model)));
    return carTransmissions;
  }

  _mapColors(List<dynamic> colors) {
    List<CarColor> carColors = [];
    colors.forEach((model) => carColors.add(CarColor.fromJson(model)));
    return carColors;
  }
}
