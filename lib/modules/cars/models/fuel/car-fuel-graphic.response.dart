import 'package:app/modules/cars/models/fuel/car-fuel-graphic-info.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel-graphic-month.model.dart';
import 'package:app/modules/cars/models/fuel/car-fuel-graphic-year.model.dart';
import 'package:bezier_chart/bezier_chart.dart';

class CarFuelGraphicResponse {
  CarFuelGraphicInfo carFuelGraphicInfo;
  String fuelConsumption;

  CarFuelGraphicResponse({this.carFuelGraphicInfo, this.fuelConsumption});

  factory CarFuelGraphicResponse.fromJson(Map<String, dynamic> json) {
    return CarFuelGraphicResponse(
        fuelConsumption:
            json['fuelConsumption'] != null ? json['fuelConsumption'] : '0.0',
        carFuelGraphicInfo: json['yearMonthCarFuelStatsInfo'] != null
            ? CarFuelGraphicInfo.fromJson(json['yearMonthCarFuelStatsInfo'])
            : null);
  }

  List<dynamic> labels() {
    List<dynamic> labels = [];

    for(CarFuelGraphicYear year in carFuelGraphicInfo.years) {
      for(CarFuelGraphicMonth month in year.months) {
        labels.add(month.labels);
      }
    }

    return labels;
  }

  List<dynamic> dataSets() {
    List<dynamic> dataSets = [];

    for(CarFuelGraphicYear year in carFuelGraphicInfo.years) {
      for(CarFuelGraphicMonth month in year.months) {
        dataSets.add(month.datasets);
      }
    }

    return dataSets;
  }

  chartScale() {
    if (carFuelGraphicInfo.years.length == 1) {
      return BezierChartScale.WEEKLY;
    }

    return BezierChartScale.MONTHLY;
  }
}
