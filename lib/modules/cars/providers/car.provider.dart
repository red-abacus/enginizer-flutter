import 'dart:io';

import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel-consumption.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel-consumption.response.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car.service.dart';
import 'package:enginizer_flutter/utils/api_response.dart';
import 'package:flutter/cupertino.dart';

class CarProvider with ChangeNotifier {
  CarService carService = inject<CarService>();

  Car selectedCar;
  Car carDetails;

  List<Car> carFuelConsumptionDataGraphic;
  CarFuelGraphicResponse carFuelGraphicResponse;

  ApiResponse uploadImageAPI = ApiResponse.completed(null);

  selectCar(Car car) {
    this.selectedCar = car;
    notifyListeners();
  }

  Future<Car> getCarDetails() async {
    carDetails = await carService.getCarDetails(selectedCar.id);
    notifyListeners();
    return carDetails;
  }

  Future<CarFuelGraphicResponse> getCarFuelConsumptionGraphic() async {
    carFuelGraphicResponse = await carService.getFuelConsumption(selectedCar.id);
    notifyListeners();
    return carFuelGraphicResponse;
  }

  Future<CarFuelConsumptionResponse> addCarFuelConsumption(CarFuelConsumption fuelConsumption) async {
    if (selectedCar != null) {
      CarFuelConsumptionResponse response = await carService.addFuelConsumption(fuelConsumption, selectedCar.id);
      notifyListeners();
      return response;
    }

    return null;
  }

  uploadImage(File file) async {
    uploadImageAPI = ApiResponse.loading("");
    try {
      var response = await carService.uploadImage(file, selectedCar.id);
      uploadImageAPI = ApiResponse.completed(response);
    } catch (error) {
      uploadImageAPI = ApiResponse.error("error");
    }
    notifyListeners();
  }
}
