import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car-fuel-consumption.model.dart';
import 'package:app/modules/cars/models/car-fuel-consumption.response.dart';
import 'package:app/modules/cars/models/car-fuel-graphic.response.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/models/recommendations/car-history.model.dart';
import 'package:app/modules/cars/models/recommendations/car-intervention.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/utils/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarProvider with ChangeNotifier {
  CarService carService = inject<CarService>();

  Car selectedCar;
  Car carDetails;

  List<Car> carFuelConsumptionDataGraphic;
  CarFuelGraphicResponse carFuelGraphicResponse;

  ApiResponse uploadImageAPI = ApiResponse.completed(null);

  List<CarHistory> carHistory = [];
  List<CarIntervention> selectedInterventions = [];

  selectCar(Car car) {
    this.selectedCar = car;
    notifyListeners();
  }

  Future<Car> getCarDetails() async {
    try {
      carDetails = await carService.getCarDetails(selectedCar.id);
      notifyListeners();
      return carDetails;
    } catch (error) {
      throw (error);
    }
  }

  Future<CarFuelGraphicResponse> getCarFuelConsumptionGraphic() async {
    try {
      carFuelGraphicResponse =
          await carService.getFuelConsumption(selectedCar.id);
      notifyListeners();
      return carFuelGraphicResponse;
    } catch (error) {
      throw (error);
    }
  }

  Future<CarFuelConsumptionResponse> addCarFuelConsumption(
      CarFuelConsumption fuelConsumption) async {
    if (selectedCar != null) {
      try {
        CarFuelConsumptionResponse response = await carService
            .addFuelConsumption(fuelConsumption, selectedCar.id);
        notifyListeners();
        return response;
      } catch (error) {
        throw (error);
      }
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

  Future<List<CarHistory>> getCarHistory(int carId) async {
    try {
      carHistory = await carService.getCarHistory(carId);
      notifyListeners();
      return carHistory;
    } catch (error) {
      throw (error);
    }
  }
}
