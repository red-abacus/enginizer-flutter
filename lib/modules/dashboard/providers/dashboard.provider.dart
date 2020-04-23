import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:flutter/cupertino.dart';

class DashboardProvider with ChangeNotifier {
  List<Car> _cars = [];

  CarService carService = inject<CarService>();

  DateTime startDate;
  DateTime endDate;
  Car selectedCar;

  initialise() {
    startDate = null;
    endDate = null;
    selectedCar = null;
  }

  List<Car> get cars {
    return _cars;
  }

  Future<List<Car>> loadCars() async {
    try {
      var response = await this.carService.getCars();
      _cars = response.items;
      notifyListeners();
      return _cars;
    } catch (error) {
      throw (error);
    }
  }
}