import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:flutter/cupertino.dart';

class CarsProvider with ChangeNotifier {
  List<Car> _cars = [];

  CarService carService = inject<CarService>();

  List<Car> get cars {
    return _cars;
  }

  Future<List<Car>> loadCars({String filterValue = ''}) async {
    var response = await this.carService.getCars();
    _cars = response.items;

    if (filterValue.isNotEmpty) {
      _cars = _cars.where((car) => car.filtered(filterValue)).toList();
    }

    notifyListeners();
    return _cars;
  }

  Future<Car> addCar(Car car) async {
    var newCar = await this.carService.addCar(car);
    _cars.add(newCar);
    notifyListeners();
    return newCar;
  }
}
