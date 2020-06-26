import 'dart:io';

import 'package:app/config/injection.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/modules/cars/models/car-document.dart';
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
import 'package:path_provider/path_provider.dart';

class CarProvider with ChangeNotifier {
  CarService carService = inject<CarService>();

  Car selectedCar;
  Car carDetails;

  List<Car> carFuelConsumptionDataGraphic;
  CarFuelGraphicResponse carFuelGraphicResponse;

  ApiResponse uploadImageAPI = ApiResponse.completed(null);

  List<CarHistory> carHistory = [];
  List<CarIntervention> selectedInterventions = [];

  CarDocument talon;
  CarDocument exhaust;
  CarDocument diagnosisProtocol;
  CarDocument generalVerification;

  initialise() {
    talon = null;
    exhaust = null;
    diagnosisProtocol = null;
    generalVerification = null;
    selectedInterventions = [];
    carHistory = [];
  }

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

  Future<GenericModel> uploadDocument(int carId, CarDocument document) async {
    try {
      GenericModel model = await carService.addCarDocument(carId, document);
      notifyListeners();
      return model;
    } catch (error) {
      throw (error);
    }
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

  Future<List<CarDocument>> getCarDocuments(int carId) async {
    try {
      List<CarDocument> list = await carService.getCarDocuments(carId);
      notifyListeners();
      return list;
    } catch (error) {
      throw (error);
    }
  }

  Future<File> getCarDocumentDetails(
      String path, int carId, CarDocument carDocument) async {
    try {
      File response =
          await carService.getCarDocumentDetails(carId, carDocument, path);
      notifyListeners();
      return response;
    } catch (error) {
      throw (error);
    }
  }
}
