import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car.service.dart';
import 'package:flutter/cupertino.dart';

class CarsProvider with ChangeNotifier {
  List<Car> _cars = [];

  CarService carService = inject<CarService>();

  List<Car> get cars {
    return _cars;
  }

  Future<List<Car>> loadCars() async {
    var response = await this.carService.getCars();
    _cars = response.items;
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
