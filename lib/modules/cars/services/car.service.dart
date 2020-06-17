import 'dart:convert';
import 'dart:io';
import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/models/request/car-request.model.dart';
import 'package:app/modules/promotions/models/request/create-promotion-request.model.dart';
import 'package:app/modules/shared/managers/permissions/permissions-car.dart';
import 'package:dio/dio.dart';

import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car-fuel-consumption.model.dart';
import 'package:app/modules/cars/models/car-fuel-consumption.response.dart';
import 'package:app/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/models/cars-reponse.model.dart';
import 'package:app/utils/environment.constants.dart';

class CarService {
  static String CAR_FUEL_EXCEPITON = 'GET_FUEL_FAILED';
  static String CAR_DETAILS_EXCEPTION = 'CAR_DETAILS_FAILED';
  static String CAR_CREATE_EXCEPTION = 'CAR_CREATE_FAILED';
  static String CAR_GET_EXCEPTION = 'CAR_GET_EXCEPTION';
  static String CAR_ADD_FUEL_EXCEPTION = 'CAR_ADD_FUEL_EXCEPTION';
  static String CAR_ADD_IMAGE_EXCEPTION = 'CAR_ADD_IMAGE_EXCEPTION';
  static String CAR_HISTORY_EXCEPTION = 'CAR_HISTORY_EXCEPTION';
  static String CAR_SELL_EXCEPTION = 'CAR_SELL_EXCEPTION';

  static const String _CAR_API_PATH = '${Environment.CARS_BASE_API}/cars';

  static const String _CAR_HISTORY_PREFIX =
      '${Environment.CARS_BASE_API}/cars/';
  static const String _CAR_HISTORY_SUFFIX = '/history';

  static const String _CAR_SELL_PREFIX = '${Environment.CARS_BASE_API}/cars/';
  static const String _CAR_SELL_SUFFIX = '/sell';

  Dio _dio = inject<Dio>();

  CarService();

  Future<CarsResponse> getCars({String searchString}) async {
    // TODO - when create a new promotion with car, i need a filtering for status
    // TODO - get cars need to retrieve status as well
    try {
      var queryParams =
          searchString != null ? {'search': searchString} : {'search': ''};

      final response =
          await _dio.get(_CAR_API_PATH, queryParameters: queryParams);

      if (response.statusCode < 300) {
        return CarsResponse.fromJson(response.data);
      } else {
        throw Exception(CAR_GET_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CAR_GET_EXCEPTION);
    }
  }

  Future<Car> addCar(CarRequest carRequest) async {
    try {
      final response =
          await _dio.post(_CAR_API_PATH, data: jsonEncode(carRequest.toJson()));

      if (response.statusCode < 300) {
        return _mapCar(response.data);
      } else {
        throw Exception(CAR_CREATE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CAR_CREATE_EXCEPTION);
    }
  }

  Car _mapCar(dynamic response) {
    return Car.fromJson(response);
  }

  Future<CarFuelConsumptionResponse> addFuelConsumption(
      CarFuelConsumption fuelConsumption, int id) async {
    try {
      final response = await _dio.post('$_CAR_API_PATH/$id/fuel',
          data: jsonEncode(fuelConsumption.toJson()));

      if (response.statusCode < 300) {
        return CarFuelConsumptionResponse.fromJson(response.data);
      } else {
        throw Exception(CAR_ADD_FUEL_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CAR_ADD_FUEL_EXCEPTION);
    }
  }

  Future<CarFuelGraphicResponse> getFuelConsumption(int id) async {
    try {
      final response = await _dio.get('$_CAR_API_PATH/$id/fuel',
          queryParameters: {
            "month": DateTime.now().month,
            'year': DateTime.now().year
          });

      if (response.statusCode < 300) {
        return CarFuelGraphicResponse.fromJson(response.data);
      } else {
        throw Exception(CAR_FUEL_EXCEPITON);
      }
    } catch (error) {
      throw Exception(CAR_FUEL_EXCEPITON);
    }
  }

  Future<Car> getCarDetails(int id) async {
    final response = await _dio.get('$_CAR_API_PATH/$id');

    if (response.statusCode < 300) {
      return Car.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error
      throw Exception(CAR_DETAILS_EXCEPTION);
    }
  }

  Future<CarFuelConsumptionResponse> uploadImage(File file, int id) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
      ),
    });

    try {
      final response =
          await _dio.patch('$_CAR_API_PATH/$id/image', data: formData);

      if (response.statusCode < 300) {
        return CarFuelConsumptionResponse.fromJson(response.data);
      } else {
        throw Exception(CAR_ADD_IMAGE_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CAR_ADD_IMAGE_EXCEPTION);
    }
  }

  Future<List<CarHistory>> getCarHistory(int carId) async {
    try {
      final response = await _dio.get(_buildCarHistoryPath(carId));

      if (response.statusCode == 200) {
        return _mapCarHistory(response.data);
      } else {
        throw Exception(CAR_HISTORY_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CAR_HISTORY_EXCEPTION);
    }
  }

  Future<Car> sellCar(CreatePromotionRequest createPromotionRequest) async {
    try {
      final response = await _dio.patch(
          _buildCarSellPath(createPromotionRequest.car.id),
          data: jsonEncode(createPromotionRequest.toJson()));

      if (response.statusCode == 200) {
        return Car.fromJson(response.data);
      } else {
        throw Exception(CAR_SELL_EXCEPTION);
      }
    } catch (error) {
      throw Exception(CAR_SELL_EXCEPTION);
    }
  }

  _buildCarHistoryPath(int carId) {
    return _CAR_HISTORY_PREFIX + carId.toString() + _CAR_HISTORY_SUFFIX;
  }

  _buildCarSellPath(int carId) {
    return _CAR_SELL_PREFIX + carId.toString() + _CAR_SELL_SUFFIX;
  }

  _mapCarHistory(List<dynamic> response) {
    List<CarHistory> histories = [];
    response.forEach((history) {
      histories.add(CarHistory.fromJson(history));
    });
    return histories;
  }
}
