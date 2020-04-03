import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car-fuel-consumption.model.dart';
import 'package:app/modules/cars/models/car-fuel-consumption.response.dart';
import 'package:app/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/models/cars-reponse.model.dart';
import 'package:app/modules/cars/providers/car.provider.dart';
import 'package:app/utils/environment.constants.dart';

class CarService {
  static const String CAR_API_PATH = '${Environment.CARS_BASE_API}/cars';

  Dio _dio = inject<Dio>();

  CarService();

  Future<CarsResponse> getCars() async {
    final response = await _dio.get(CAR_API_PATH);

    if (response.statusCode < 300) {
      // If server returns an OK response, parse the JSON.

      return CarsResponse.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Car> addCar(Car car) async {
    final response =
        await _dio.post(CAR_API_PATH, data: jsonEncode(car.toJson()));

    if (response.statusCode < 300) {
      // If server returns an OK response, parse the JSON.

      return _mapCar(response.data);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('CREATE_CAR_FAILED');
    }
  }

  Car _mapCar(dynamic response) {
    return Car.fromJson(response);
  }

  Future<CarFuelConsumptionResponse> addFuelConsumption(
      CarFuelConsumption fuelConsumption, int id) async {
    final response = await _dio.post('$CAR_API_PATH/$id/fuel',
        data: jsonEncode(fuelConsumption.toJson()));

    if (response.statusCode < 300) {
      return CarFuelConsumptionResponse.fromJson(response.data);
    } else {
      throw Exception('ADD_FUEL_FAILED');
    }
  }

  Future<CarFuelGraphicResponse> getFuelConsumption(int id) async {
    try {
      final response = await _dio.get(
          '$CAR_API_PATH/$id/fuel', queryParameters: {
        "month": DateTime
            .now()
            .month,
        'year': DateTime
            .now()
            .year
      });

      if (response.statusCode < 300) {
        return CarFuelGraphicResponse.fromJson(response.data);
      } else {
        throw Exception(CarProvider.CAR_FUEL_EXCEPITON);
      }
    }
    catch(error) {
      throw Exception(CarProvider.CAR_FUEL_EXCEPITON);
    }
  }

  Future<Car> getCarDetails(int id) async {
    final response = await _dio.get('$CAR_API_PATH/$id');

    if (response.statusCode < 300) {
      return Car.fromJson(response.data);
    } else {
      // If that response was not OK, throw an error
      throw Exception(CarProvider.CAR_DETAILS_EXCEPTION);
    }
  }

  Future<CarFuelConsumptionResponse> uploadImage(File file, int id) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
      ),
    });

    final response =
        await _dio.patch('$CAR_API_PATH/$id/image', data: formData);

    if (response.statusCode < 300) {
      return CarFuelConsumptionResponse.fromJson(response.data);
    } else {
      throw Exception('UPLOAD_IMAGE_FAILED');
    }
  }
}
