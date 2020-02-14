import 'dart:io';

import 'package:enginizer_flutter/config/injection.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel-comsumtion.model.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel-comsumtion.response.dart';
import 'package:enginizer_flutter/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:enginizer_flutter/modules/cars/models/car.model.dart';
import 'package:enginizer_flutter/modules/cars/services/car.service.dart';
import 'package:enginizer_flutter/utils/api_response.dart';
import 'package:flutter/cupertino.dart';

class CarProvider with ChangeNotifier {
  CarService carService = inject<CarService>();

  Car selectedCar;
  List<Car> carFuelConsumptionDataGraphic;

  ApiResponse getCarDetailsAPI = ApiResponse.loading("init");
  ApiResponse getCarFuelConsumptionAPI = ApiResponse.loading(null);
  ApiResponse uploadImageAPI = ApiResponse.completed(null);

  selectCar(Car car) {
    this.selectedCar = car;
    notifyListeners();
  }

  getCarDetails() async {
    getCarDetailsAPI = ApiResponse.loading("add");
    try {
      var response = await carService.getCarDetails(selectedCar.id);
      getCarDetailsAPI = ApiResponse.completed(response);
    } catch (error) {
      getCarDetailsAPI = ApiResponse.error("error");
    }
    notifyListeners();
  }

  getCarFuelConsumptionGraphic() async {
    getCarFuelConsumptionAPI = ApiResponse.loading("add");
    try {
      CarFuelGraphicResponse response = await carService.getFuelConsumption(selectedCar.id);
      getCarFuelConsumptionAPI = ApiResponse.completed(response);
    } catch (error) {
      getCarFuelConsumptionAPI = ApiResponse.error("error");
    }
    notifyListeners();
  }

  addCarFuelConsumption(CarFuelConsumption fuelConsumption) async {
    await carService.addFuelConsumption(fuelConsumption, selectedCar.id);
    getCarFuelConsumptionGraphic();
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
