import 'package:app/config/injection.dart';
import 'package:app/modules/cars/enums/car-status.enum.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/models/request/car-request.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:flutter/cupertino.dart';

class CarsProvider with ChangeNotifier {
  List<Car> _cars = [];

  CarService carService = inject<CarService>();

  bool initDone = false;

  List<Car> get cars {
    return _cars;
  }

  Future<List<Car>> loadCars({String filterValue = ''}) async {
    try {
      var response = await this.carService.getCars();
      _cars = response.items;

      if (filterValue.isNotEmpty) {
        _cars = _cars.where((car) => car.filtered(filterValue)).toList();
      }

      notifyListeners();
      return _cars;
    } catch (error) {
      throw (error);
    }
  }

  Future<Car> addCar(CarRequest carRequest) async {
    try {
      var newCar = await this.carService.addCar(carRequest);
      _cars.add(newCar);
      notifyListeners();
      return newCar;
    } catch (error) {
      throw (error);
    }
  }
}
