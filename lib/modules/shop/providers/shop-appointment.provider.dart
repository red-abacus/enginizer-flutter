import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/shop/models/shop-appointment-issue.model.dart';
import 'package:flutter/cupertino.dart';

class ShopAppointmentProvider with ChangeNotifier {
  CarService carService = inject<CarService>();

  List<Car> cars;
  List<ShopAppointmentIssue> issues;

  Car selectedCar;

  String searchString;

  initialiseParameters() {
    selectedCar = null;
    cars = [];
    searchString = '';
    issues = [];
  }

  Future<List<Car>> loadCars() async {
    try {
      var response = await this.carService.getCars(searchString: searchString);
      cars = response.items;
      notifyListeners();
      return cars;
    } catch (error) {
      throw (error);
    }
  }
}
