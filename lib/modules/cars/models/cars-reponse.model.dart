import 'package:enginizer_flutter/modules/cars/models/car.model.dart';

class CarsResponse {
  int total;
  int totalPages;
  List<Car> items;

  CarsResponse({this.total, this.totalPages, this.items});

  factory CarsResponse.fromJson(Map<String, dynamic> json) {
    return CarsResponse(
        total: json['total'],
        totalPages: json['totalPages'],
        items: _mapCars(json['items']));
  }

  static _mapCars(List<dynamic> response) {
    List<Car> carList = [];
    response.forEach((item) {
      carList.add(Car.fromJson(item));
    });
    return carList;
  }
}
