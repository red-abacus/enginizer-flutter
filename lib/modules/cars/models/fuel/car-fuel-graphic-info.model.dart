import 'package:app/modules/cars/models/fuel/car-fuel-graphic-year.model.dart';

class CarFuelGraphicInfo {
  List<CarFuelGraphicYear> years = List();

  CarFuelGraphicInfo();

  factory CarFuelGraphicInfo.fromJson(Map<String, dynamic> json) {
    var info = CarFuelGraphicInfo();

    for(String key in json.keys) {
      info.years.add(CarFuelGraphicYear.fromJson(key, json[key]));
    }

    return info;
  }
}
