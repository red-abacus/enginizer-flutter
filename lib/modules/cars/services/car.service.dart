import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/models/cars-reponse.model.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';

class CarService {
  static const String CAR_API_PATH = '${Environment.CARS_BASE_API}/cars';

  Dio _dio = inject<Dio>();

  CarService();

  Future<CarsResponse> getCars() async {
    final response = await _dio.get(CAR_API_PATH);

    if (response.statusCode == 200) {
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

    if (response.statusCode == 201) {
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
}
