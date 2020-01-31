import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/models/cars-reponse.model.dart';
import 'package:enginizer_flutter/utils/environment.constants.dart';
import 'package:http/http.dart' as http;

class CarService {
  static const String CAR_API_PATH = '${Environment.CARS_BASE_API}/cars';

  CarService();

  Future<CarsResponse> getCars() async {
    final response = await http.get(CAR_API_PATH);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      Map<String, dynamic> parsed = jsonDecode(response.body);

      return CarsResponse.fromJson(parsed);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Car> addCar(Car car) async {
    print(car.toJson());
    final response =
        await http.post(CAR_API_PATH, body: jsonEncode(car.toJson()), headers: {
      Headers.contentTypeHeader: 'application/json', // set content-length
    });

    if (response.statusCode == 201) {
      // If server returns an OK response, parse the JSON.

      Map<String, dynamic> parsed = jsonDecode(response.body);

      return _mapCar(parsed);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('CREATE_CAR_FAILED');
    }
  }

  List<Car> _mapCars(List<dynamic> response) {
    List<Car> carList = [];
    response.forEach((item) {
      carList.add(Car.fromJson(item));
    });
    return carList;
  }

  Car _mapCar(dynamic response) {
    return Car.fromJson(response);
  }
}
