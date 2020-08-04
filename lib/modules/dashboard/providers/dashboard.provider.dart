import 'package:app/config/injection.dart';
import 'package:app/modules/cars/models/car.model.dart';
import 'package:app/modules/cars/services/car.service.dart';
import 'package:app/modules/dashboard/models/reports.model.dart';
import 'package:app/modules/dashboard/models/request/reports-request.model.dart';
import 'package:app/modules/dashboard/services/reports.service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  CarService _carService = inject<CarService>();
  ReportsService _reportsService = inject<ReportsService>();

  List<Car> _cars = [];

  ReportsRequest reportsRequest;
  Reports reports;

  initialise() {
    reportsRequest = new ReportsRequest();
    reports = null;
  }

  List<Car> get cars {
    return _cars;
  }

  Future<List<Car>> loadCars() async {
    try {
      var response = await this._carService.getCars();
      _cars = response.items;
      notifyListeners();
      return _cars;
    } catch (error) {
      throw (error);
    }
  }

  Future<Reports> getReports(ReportsRequest reportsRequest) async {
    try {
      reports = await _reportsService.getReports(reportsRequest);
      notifyListeners();
      return reports;
    }
    catch (error) {
      throw(error);
    }
  }
}
