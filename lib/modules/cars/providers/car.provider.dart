import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:flutter/cupertino.dart';

class CarProvider with ChangeNotifier {
  Car _selectedCar;

  Car get selectedCar {
    return _selectedCar;
  }

  selectCar(Car car) {
    this._selectedCar = car;
    notifyListeners();
  }
}
